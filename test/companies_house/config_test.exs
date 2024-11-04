defmodule CompaniesHouse.ConfigTest do
  use ExUnit.Case
  doctest CompaniesHouse.Config

  alias CompaniesHouse.Config

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
end
