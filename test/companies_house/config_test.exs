defmodule CompaniesHouse.ConfigTest do
  use ExUnit.Case
  doctest CompaniesHouse.Config

  alias CompaniesHouse.Config

  setup do
    # Save existing environment
    original_env = Application.get_env(:companies_house, :environment)

    # Clean up after tests
    on_exit(fn ->
      if is_nil(original_env) do
        Application.delete_env(:companies_house, :environment)
      else
        Application.put_env(:companies_house, :environment, original_env)
      end
    end)

    :ok
  end

  describe "get/2" do
    test "when key exists" do
      Application.put_env(:companies_house, :key, 1)
      assert Config.get(:key) == 1
      Application.delete_env(:companies_house, :key)
    end

    test "when key does not exist and with a default value" do
      assert Config.get(:key, "some default") == "some default"
    end

    test "when key does not exist and without a default value" do
      assert Config.get(:key) == nil
    end
  end

  describe "put/3" do
    test "inserts key value pair" do
      config = [something: "some value"]
      assert Config.put(config, :key, 1) == [key: 1, something: "some value"]
    end
  end

  describe "raise_error/1" do
    test "raises expected exception" do
      assert_raise Config.ConfigError, "some specific error", fn ->
        Config.raise_error("some specific error")
      end
    end
  end

  describe "environment/0" do
    test "returns configured environment" do
      Application.put_env(:companies_house, :environment, :live)
      assert Config.environment() == :live
    end

    test "returns default environment when not configured" do
      Application.delete_env(:companies_house, :environment)
      assert Config.environment() == :sandbox
    end

    test "validates environment value" do
      Application.put_env(:companies_house, :environment, :invalid)

      assert_raise Config.ConfigError, ~r/Invalid environment/, fn ->
        Config.environment()
      end
    end
  end
end
