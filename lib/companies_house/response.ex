defmodule CompaniesHouse.Response do
  @moduledoc """
  The response type returned by all public API functions.

  Successful responses return `{:ok, map()}` with the parsed JSON body.

  Errors take one of two shapes:
  - `{:error, {status_code, body}}` — the API returned a non-2xx HTTP response
  - `{:error, exception}` — a network or transport failure (e.g. timeout, DNS failure)
  """

  @type error :: {pos_integer(), map()} | Exception.t()
  @type t :: {:ok, map() | [map()]} | {:error, error()}
end
