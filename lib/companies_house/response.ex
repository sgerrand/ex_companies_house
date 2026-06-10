defmodule CompaniesHouse.Response do
  @moduledoc """
  The response type returned by all public API functions.

  Successful responses return `{:ok, body}` with the parsed body. The body is
  usually a JSON object (`map()`) or array (`[map()]`), but a non-JSON 2xx
  response (e.g. malformed JSON the decoder leaves untouched) yields the raw
  `binary()`.

  Errors take one of two shapes:
  - `{:error, {status_code, body}}` — the API returned a non-2xx HTTP response
  - `{:error, exception}` — a network or transport failure (e.g. timeout, DNS failure)
  """

  @type body :: map() | [map()] | binary()
  @type error :: {pos_integer(), body()} | Exception.t()
  @type t :: {:ok, body()} | {:error, error()}
end
