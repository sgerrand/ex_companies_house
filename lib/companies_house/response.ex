defmodule CompaniesHouse.Response do
  @moduledoc """
  The response tuple.
  """

  @type t :: {:ok, map()} | {:error, any()}
end
