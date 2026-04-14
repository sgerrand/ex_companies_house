defmodule CompaniesHouse.Response do
  @moduledoc """
  The response tuple.
  """

  @type t :: {:ok, map() | [map()]} | {:error, any()}
end
