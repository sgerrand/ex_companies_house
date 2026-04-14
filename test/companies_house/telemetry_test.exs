defmodule CompaniesHouse.TelemetryTest do
  use ExUnit.Case, async: false

  alias CompaniesHouse.Client
  alias CompaniesHouse.Client.Req, as: ReqClient

  @handler_id "companies-house-telemetry-test"

  setup do
    Application.put_env(:companies_house, :api_key, "test-key")

    on_exit(fn ->
      Application.delete_env(:companies_house, :api_key)
      :telemetry.detach(@handler_id)
    end)

    :ok
  end

  describe "[:companies_house, :request, :start]" do
    setup [:setup_bypass]

    @tag path: "/company/12345678"
    test "emits start event before the request", c do
      test_pid = self()

      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :start],
        fn _event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_start, measurements, metadata})
        end,
        nil
      )

      Bypass.expect_once(c.bypass, "GET", c.path, fn conn ->
        Plug.Conn.resp(conn, 200, ~s({}))
      end)

      ReqClient.get(c.url, c.client)

      assert_receive {:telemetry_start, measurements, metadata}
      assert is_integer(measurements.system_time)
      assert metadata.method == :get
      assert metadata.environment == :sandbox
    end
  end

  describe "[:companies_house, :request, :stop]" do
    setup [:setup_bypass]

    @tag path: "/company/12345678"
    test "emits stop event with status after successful request", c do
      test_pid = self()

      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :stop],
        fn _event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_stop, measurements, metadata})
        end,
        nil
      )

      Bypass.expect_once(c.bypass, "GET", c.path, fn conn ->
        Plug.Conn.resp(conn, 200, ~s({"company_name": "Test Ltd"}))
      end)

      ReqClient.get(c.url, c.client)

      assert_receive {:telemetry_stop, measurements, metadata}
      assert is_integer(measurements.duration)
      assert measurements.duration >= 0
      assert metadata.method == :get
      assert metadata.status == 200
      assert metadata.environment == :sandbox
    end

    @tag path: "/company/missing"
    test "emits stop event with status for non-2xx responses", c do
      test_pid = self()

      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :stop],
        fn _event, _measurements, metadata, _config ->
          send(test_pid, {:telemetry_stop, metadata})
        end,
        nil
      )

      Bypass.expect_once(c.bypass, "GET", c.path, fn conn ->
        Plug.Conn.resp(conn, 404, ~s({"error": "not found"}))
      end)

      ReqClient.get(c.url, c.client)

      assert_receive {:telemetry_stop, metadata}
      assert metadata.status == 404
    end
  end

  describe "[:companies_house, :request, :exception]" do
    test "emits exception event on transport error" do
      test_pid = self()

      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :exception],
        fn _event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_exception, measurements, metadata})
        end,
        nil
      )

      # Port 1 refuses connections immediately
      client = %Client{environment: :sandbox}
      ReqClient.get("http://localhost:1/company/12345678", client)

      assert_receive {:telemetry_exception, measurements, metadata}, 15_000
      assert is_integer(measurements.duration)
      assert metadata.method == :get
      assert metadata.kind == :error
      assert metadata.environment == :sandbox
    end
  end

  defp setup_bypass(%{path: path}) do
    bypass = Bypass.open()
    client = %Client{environment: :sandbox}
    url = "http://localhost:#{bypass.port}#{path}"
    [bypass: bypass, client: client, url: url]
  end
end
