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
end
