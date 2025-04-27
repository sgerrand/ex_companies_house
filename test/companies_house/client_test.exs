defmodule CompaniesHouse.ClientTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest CompaniesHouse.Client

  alias CompaniesHouse.Client
  alias CompaniesHouse.ClientMock

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

    test "delete/2 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :delete, 2)

      expect(ClientMock, :delete, fn path, received_client ->
        assert path == "some-delete-path"
        assert received_client == client
        "delete-result"
      end)

      assert Client.delete("some-delete-path", client) == "delete-result"
    end

    test "delete/1 uses default client" do
      assert function_exported?(Client, :delete, 1)

      expect(ClientMock, :delete, fn path, received_client ->
        assert path == "some-delete-path"
        assert received_client == %Client{}
        "delete-result"
      end)

      assert Client.delete("some-delete-path") == "delete-result"
    end

    test "get/2 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :get, 2)

      expect(ClientMock, :get, fn path, received_client ->
        assert path == "some-get-path"
        assert received_client == client
        "get-result"
      end)

      assert Client.get("some-get-path", client) == "get-result"
    end

    test "get/3 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :get, 3)

      expect(ClientMock, :get, fn path, params, received_client ->
        assert path == "some-get-path"
        assert params == [some_key: "some-value"]
        assert received_client == client
        "get-result"
      end)

      assert Client.get("some-get-path", [some_key: "some-value"], client) == "get-result"
    end

    test "post/3 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :post, 3)

      expect(ClientMock, :post, fn path, params, received_client ->
        assert path == "some-post-path"
        assert params == [some_key: "some-value"]
        assert received_client == client
        "post-result"
      end)

      assert Client.post("some-post-path", [some_key: "some-value"], client) == "post-result"
    end

    test "post/2 uses default client" do
      assert function_exported?(Client, :post, 2)

      expect(ClientMock, :post, fn path, params, received_client ->
        assert path == "some-post-path"
        assert params == [some_key: "some-value"]
        assert received_client == %Client{}
        "post-result"
      end)

      assert Client.post("some-post-path", some_key: "some-value") == "post-result"
    end

    test "post/1 uses default params and client" do
      assert function_exported?(Client, :post, 1)

      expect(ClientMock, :post, fn path, params, received_client ->
        assert path == "some-post-path"
        assert params == []
        assert received_client == %Client{}
        "post-result"
      end)

      assert Client.post("some-post-path") == "post-result"
    end

    test "put/3 delegates to implementation", %{client: client} do
      assert function_exported?(Client, :put, 3)

      expect(ClientMock, :put, fn path, params, received_client ->
        assert path == "some-put-path"
        assert params == [some_key: "some-value"]
        assert received_client == client
        "put-result"
      end)

      assert Client.put("some-put-path", [some_key: "some-value"], client) == "put-result"
    end

    test "put/2 uses default client" do
      assert function_exported?(Client, :put, 2)

      expect(ClientMock, :put, fn path, params, received_client ->
        assert path == "some-put-path"
        assert params == [some_key: "some-value"]
        assert received_client == %Client{}
        "put-result"
      end)

      assert Client.put("some-put-path", some_key: "some-value") == "put-result"
    end

    test "put/1 uses default params and client" do
      assert function_exported?(Client, :put, 1)

      expect(ClientMock, :put, fn path, params, received_client ->
        assert path == "some-put-path"
        assert params == []
        assert received_client == %Client{}
        "put-result"
      end)

      assert Client.put("some-put-path") == "put-result"
    end
  end
end
