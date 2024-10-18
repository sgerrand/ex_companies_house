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
end
