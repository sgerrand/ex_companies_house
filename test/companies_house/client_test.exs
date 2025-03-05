defmodule CompaniesHouse.ClientTest do
  use ExUnit.Case, async: true

  doctest CompaniesHouse.Client

  describe "struct" do
    test "defaults environment to sandbox" do
      actual = %CompaniesHouse.Client{}
      assert actual.environment == :sandbox
    end

    test "can set environment to live" do
      actual = %CompaniesHouse.Client{environment: :live}
      assert actual.environment == :live
    end
  end

  describe "new/0" do
    test "creates client with default sandbox environment" do
      client = CompaniesHouse.Client.new()
      assert client.environment == :sandbox
    end
  end

  describe "new/1" do
    test "creates client with specified environment" do
      client = CompaniesHouse.Client.new(:live)
      assert client.environment == :live
    end

    test "raises error for invalid environment" do
      assert_raise ArgumentError, ~r/Invalid environment/, fn ->
        CompaniesHouse.Client.new(:invalid)
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
      client = CompaniesHouse.Client.from_config()
      assert client.environment == :live
    end

    test "uses default environment when not configured" do
      Application.delete_env(:companies_house, :environment)
      client = CompaniesHouse.Client.from_config()
      assert client.environment == :sandbox
    end
  end
end
