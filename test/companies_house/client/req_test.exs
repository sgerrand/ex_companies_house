defmodule CompaniesHouse.Client.ReqTest do
  use ExUnit.Case, async: true

  doctest CompaniesHouse.Client.Req

  alias CompaniesHouse.Client
  alias CompaniesHouse.Client.Req, as: ReqClient

  setup do
    api_key = "some API key"
    Application.put_env(:companies_house, :api_key, api_key)
    on_exit(fn -> Application.delete_env(:companies_house, :api_key) end)

    [api_key: api_key]
  end

  describe "new/1" do
    test "by default configures sandbox url" do
      client = ReqClient.new()

      assert Map.has_key?(client, :options)
      assert Map.has_key?(client.options, :base_url)
      assert client.options.base_url == "https://api-sandbox.company-information.service.gov.uk"
    end

    test "configures live url when given live environment" do
      client = ReqClient.new(%Client{environment: :live})

      assert Map.has_key?(client, :options)
      assert Map.has_key?(client.options, :base_url)
      assert client.options.base_url == "https://api.company-information.service.gov.uk"
    end

    test "configures sandbox url when given sandbox environment" do
      client = ReqClient.new(%Client{environment: :sandbox})

      assert Map.has_key?(client, :options)
      assert Map.has_key?(client.options, :base_url)
      assert client.options.base_url == "https://api-sandbox.company-information.service.gov.uk"
    end
  end

  describe "delete/2" do
    setup [:setup_bypass]

    @tag path: "/delete"
    test "requests expected path", c do
      Bypass.expect(c.bypass, "DELETE", c[:path], fn conn ->
        assert ["Basic c29tZSBBUEkga2V5"] == Plug.Conn.get_req_header(conn, "authorization")
        Plug.Conn.send_resp(conn, 200, "deleted")
      end)

      {:ok, response} = ReqClient.delete(c.url, c.client)
      assert "deleted" == response.body
    end
  end

  describe "get/2" do
    setup [:setup_bypass]

    @tag path: "/get"
    test "requests expected path", c do
      Bypass.expect(c.bypass, "GET", c[:path], fn conn ->
        assert ["Basic c29tZSBBUEkga2V5"] == Plug.Conn.get_req_header(conn, "authorization")
        Plug.Conn.send_resp(conn, 200, "fetched")
      end)

      {:ok, response} = ReqClient.get(c.url, c.client)
      assert "fetched" == response.body
    end
  end

  describe "get/3" do
    setup [:setup_bypass]

    @tag path: "/get"
    test "requests expected path", c do
      Bypass.expect(c.bypass, "GET", c[:path], fn conn ->
        assert ["Basic c29tZSBBUEkga2V5"] == Plug.Conn.get_req_header(conn, "authorization")
        assert conn.query_string == "some=params"
        Plug.Conn.send_resp(conn, 200, "fetched")
      end)

      {:ok, response} = ReqClient.get(c.url, [some: "params"], c.client)
      assert "fetched" == response.body
    end
  end

  describe "post/3" do
    setup [:setup_bypass]

    @tag path: "/post"
    test "requests expected path", c do
      Bypass.expect(c.bypass, "POST", c[:path], fn conn ->
        assert ["Basic c29tZSBBUEkga2V5"] == Plug.Conn.get_req_header(conn, "authorization")
        assert conn.query_string == "some=params"
        Plug.Conn.send_resp(conn, 200, "fetched")
      end)

      {:ok, response} = ReqClient.post(c.url, [some: "params"], c.client)
      assert "fetched" == response.body
    end
  end

  describe "put/3" do
    setup [:setup_bypass]

    @tag path: "/put"
    test "requests expected path", c do
      Bypass.expect(c.bypass, "GET", c[:path], fn conn ->
        assert ["Basic c29tZSBBUEkga2V5"] == Plug.Conn.get_req_header(conn, "authorization")
        assert conn.query_string == "some=params"
        Plug.Conn.send_resp(conn, 200, "fetched")
      end)

      {:ok, response} = ReqClient.get(c.url, [some: "params"], c.client)
      assert "fetched" == response.body
    end
  end

  defp setup_bypass(%{path: path}) do
    bypass = Bypass.open()
    client = %Client{environment: :sandbox}
    req = ReqClient.new(client)

    url =
      case path do
        nil ->
          "http://localhost:#{bypass.port}"

        _ ->
          "http://localhost:#{bypass.port}#{path}"
      end

    [bypass: bypass, client: client, req: req, url: url]
  end
end