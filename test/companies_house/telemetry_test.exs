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
      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :start],
        &__MODULE__.handle_start/4,
        self()
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
      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :stop],
        &__MODULE__.handle_stop/4,
        self()
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
      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :stop],
        &__MODULE__.handle_stop_metadata_only/4,
        self()
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
      :telemetry.attach(
        @handler_id,
        [:companies_house, :request, :exception],
        &__MODULE__.handle_exception/4,
        self()
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

  def handle_start(_event, measurements, metadata, test_pid) do
    send(test_pid, {:telemetry_start, measurements, metadata})
  end

  def handle_stop(_event, measurements, metadata, test_pid) do
    send(test_pid, {:telemetry_stop, measurements, metadata})
  end

  def handle_stop_metadata_only(_event, _measurements, metadata, test_pid) do
    send(test_pid, {:telemetry_stop, metadata})
  end

  def handle_exception(_event, measurements, metadata, test_pid) do
    send(test_pid, {:telemetry_exception, measurements, metadata})
  end

  defp setup_bypass(%{path: path}) do
    bypass = Bypass.open()
    client = %Client{environment: :sandbox}
    url = "http://localhost:#{bypass.port}#{path}"
    [bypass: bypass, client: client, url: url]
  end
end
