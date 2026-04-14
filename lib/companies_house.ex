defmodule CompaniesHouse do
  @moduledoc """
  Client for the [Companies House API](https://developer-specs.company-information.service.gov.uk/).

  ## Configuration

  Set your API key in your application config:

      config :companies_house, api_key: "your-api-key"

  By default the client targets the sandbox environment. To use the live API:

      config :companies_house, environment: :live

  ## Usage

      # Fetch a company profile using the default (sandbox) client
      {:ok, profile} = CompaniesHouse.get_company_profile("00000006")

      # Use the live environment
      client = CompaniesHouse.Client.new(:live)
      {:ok, officers} = CompaniesHouse.list_company_officers("00000006", [], client)

  ## Streaming / auto-pagination

  The `stream_*` functions automatically paginate through all results, fetching
  100 items per page and yielding each item individually. They return a lazy
  `Stream` (an `Enumerable`), so you can pipe them into `Enum` functions:

      # Collect all officers for a company
      all_officers = CompaniesHouse.stream_company_officers("00000006") |> Enum.to_list()

      # Stream lazily — only fetch pages as needed
      CompaniesHouse.stream_filing_history("00000006")
      |> Stream.filter(&(&1["type"] == "AA"))
      |> Enum.take(5)

  If the API returns an error for any page, that page is silently skipped and
  the stream stops.
  """

  alias CompaniesHouse.Client
  alias CompaniesHouse.Response

  # Company Profile
  @spec get_company_profile(company_number :: String.t(), client :: Client.t()) :: Response.t()
  def get_company_profile(company_number, client \\ %Client{}) do
    http_client().get("/company/#{company_number}", client)
    |> handle_response()
  end

  # Registered Office Address
  @spec get_registered_office_address(company_number :: String.t(), client :: Client.t()) ::
          Response.t()
  def get_registered_office_address(company_number, client \\ %Client{}) do
    http_client().get("/company/#{company_number}/registered-office-address", client)
    |> handle_response()
  end

  # Officers
  @spec list_company_officers(
          company_number :: String.t(),
          params :: keyword(),
          client :: Client.t()
        ) :: Response.t()
  def list_company_officers(company_number, params \\ [], client \\ %Client{}) do
    http_client().get("/company/#{company_number}/officers", params, client)
    |> handle_response()
    |> maybe_extract_items()
  end

  @spec get_officer_appointment(String.t(), String.t(), client :: Client.t()) :: Response.t()
  def get_officer_appointment(company_number, appointment_id, client \\ %Client{}) do
    http_client().get("/company/#{company_number}/appointments/#{appointment_id}", client)
    |> handle_response()
  end

  # Filing History
  @spec list_filing_history(String.t(), keyword(), client :: Client.t()) :: Response.t()
  def list_filing_history(company_number, params \\ [], client \\ %Client{}) do
    http_client().get("/company/#{company_number}/filing-history", params, client)
    |> handle_response()
    |> maybe_extract_items()
  end

  @spec get_filing_history(String.t(), String.t(), client :: Client.t()) :: Response.t()
  def get_filing_history(company_number, transaction_id, client \\ %Client{}) do
    http_client().get("/company/#{company_number}/filing-history/#{transaction_id}", client)
    |> handle_response()
  end

  # Persons with Significant Control (PSC)
  @spec list_persons_with_significant_control(String.t(), keyword(), client :: Client.t()) ::
          Response.t()
  def list_persons_with_significant_control(company_number, params \\ [], client \\ %Client{}) do
    http_client().get(
      "/company/#{company_number}/persons-with-significant-control",
      params,
      client
    )
    |> handle_response()
    |> maybe_extract_items()
  end

  @spec get_person_with_significant_control(String.t(), String.t(), client :: Client.t()) ::
          Response.t()
  def get_person_with_significant_control(company_number, psc_id, client \\ %Client{}) do
    http_client().get(
      "/company/#{company_number}/persons-with-significant-control/individual/#{psc_id}",
      client
    )
    |> handle_response()
  end

  # Streaming / auto-pagination

  @doc """
  Streams all officers for a company, automatically paginating through results.

  Fetches up to 100 items per page and yields each officer individually. The
  stream is lazy: pages are only fetched as items are consumed.

  Returns an `Enumerable` (a lazy `Stream`).
  """
  @spec stream_company_officers(String.t(), keyword(), Client.t()) :: Enumerable.t()
  def stream_company_officers(company_number, params \\ [], client \\ %Client{}) do
    stream_paginated("/company/#{company_number}/officers", params, client)
  end

  @doc """
  Streams all filing history entries for a company, automatically paginating
  through results.

  Fetches up to 100 items per page and yields each filing history entry
  individually. The stream is lazy: pages are only fetched as items are consumed.

  Returns an `Enumerable` (a lazy `Stream`).
  """
  @spec stream_filing_history(String.t(), keyword(), Client.t()) :: Enumerable.t()
  def stream_filing_history(company_number, params \\ [], client \\ %Client{}) do
    stream_paginated("/company/#{company_number}/filing-history", params, client)
  end

  @doc """
  Streams all persons with significant control for a company, automatically
  paginating through results.

  Fetches up to 100 items per page and yields each person individually. The
  stream is lazy: pages are only fetched as items are consumed.

  Returns an `Enumerable` (a lazy `Stream`).
  """
  @spec stream_persons_with_significant_control(String.t(), keyword(), Client.t()) ::
          Enumerable.t()
  def stream_persons_with_significant_control(company_number, params \\ [], client \\ %Client{}) do
    stream_paginated(
      "/company/#{company_number}/persons-with-significant-control",
      params,
      client
    )
  end

  # Search

  @doc """
  Searches for companies matching the given query string.

  Returns the full response envelope, including pagination fields such as
  `"total_results"` and `"start_index"` alongside `"items"`. This differs
  from the list functions (e.g. `list_company_officers/3`) which extract
  only the items array.
  """
  @spec search_companies(query :: String.t(), params :: keyword(), client :: Client.t()) ::
          Response.t()
  def search_companies(query, params \\ [], client \\ %Client{}) do
    http_client().get("/search/companies", [q: query] ++ params, client)
    |> handle_response()
  end

  @doc """
  Searches for officers matching the given query string.

  Returns the full response envelope, including pagination fields such as
  `"total_results"` and `"start_index"` alongside `"items"`. This differs
  from the list functions (e.g. `list_company_officers/3`) which extract
  only the items array.
  """
  @spec search_officers(query :: String.t(), params :: keyword(), client :: Client.t()) ::
          Response.t()
  def search_officers(query, params \\ [], client \\ %Client{}) do
    http_client().get("/search/officers", [q: query] ++ params, client)
    |> handle_response()
  end

  defp stream_paginated(path, params, client) do
    Stream.unfold({0, false}, fn
      {_start, true} ->
        nil

      {start_index, false} ->
        merged_params = Keyword.merge(params, start_index: start_index, items_per_page: 100)

        case http_client().get(path, merged_params, client) |> handle_response() do
          {:ok, %{"items" => items, "total_results" => total}} ->
            done = start_index + length(items) >= total
            {items, {start_index + length(items), done}}

          {:ok, %{"items" => items}} ->
            {items, {start_index + length(items), true}}

          _ ->
            nil
        end
    end)
    |> Stream.flat_map(& &1)
  end

  defp maybe_extract_items({:ok, %{"items" => items}}), do: {:ok, items}

  defp maybe_extract_items(response_tuple), do: response_tuple

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error

  @http_client Application.compile_env(:companies_house, :http_client, CompaniesHouse.Client.Req)
  defp http_client, do: @http_client
end
