defmodule CompaniesHouse.ClientTest do
  use ExUnit.Case, async: false

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest CompaniesHouse.Client

  alias CompaniesHouse.Client
  alias CompaniesHouse.MockHTTPClient

  describe "struct" do
    test "defaults environment to sandbox" do
      actual = %Client{}
      assert actual.environment == :sandbox
    end

    test "can set environment to live" do
      actual = %Client{environment: :live}
      assert actual.environment == :live
    end
  end

  describe "new/0" do
    test "creates client with default sandbox environment" do
      client = Client.new()
      assert client.environment == :sandbox
    end
  end

  describe "new/1" do
    test "creates client with specified environment" do
      client = Client.new(:live)
      assert client.environment == :live
    end

    test "raises error for invalid environment" do
      assert_raise ArgumentError, ~r/Invalid environment/, fn ->
        Client.new(:invalid)
      end
    end
  end

  describe "from_config/0" do
    setup do
      original_env = Application.get_env(:companies_house, :environment)

      on_exit(fn ->
        if is_nil(original_env) do
          Application.delete_env(:companies_house, :environment)
        else
          Application.put_env(:companies_house, :environment, original_env)
        end
      end)

      :ok
    end

    test "creates client from application config" do
      Application.put_env(:companies_house, :environment, :live)
      client = Client.from_config()
      assert client.environment == :live
    end

    test "uses default environment when not configured" do
      Application.delete_env(:companies_house, :environment)
      client = Client.from_config()
      assert client.environment == :sandbox
    end
  end

  describe "delegation functions" do
    setup :verify_on_exit!

    setup do
      client = %Client{environment: :live}
      {:ok, client: client}
    end

    test "get/2 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :get, 2)

      expect(MockHTTPClient, :get, fn path, received_client ->
        assert path == "some-get-path"
        assert received_client == client
        "get-result"
      end)

      assert Client.get("some-get-path", client) == "get-result"
    end

    test "get/3 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :get, 3)

      expect(MockHTTPClient, :get, fn path, params, received_client ->
        assert path == "some-get-path"
        assert params == [some_key: "some-value"]
        assert received_client == client
        "get-result"
      end)

      assert Client.get("some-get-path", [some_key: "some-value"], client) == "get-result"
    end
  end
end
