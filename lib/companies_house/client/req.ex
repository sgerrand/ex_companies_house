defmodule CompaniesHouse.Client.Req do
  @moduledoc """
  Documentation for `CompaniesHouse.Client.Req`.
  """

  @behaviour CompaniesHouse.Client

  require Req

  alias CompaniesHouse.Client
  alias CompaniesHouse.Config
  alias CompaniesHouse.Response

  @base_live_url "https://api.company-information.service.gov.uk"
  @base_sandbox_url "https://api-sandbox.company-information.service.gov.uk"

  @doc """
  Creates a new client for interacting with the Companies House API.
  """
  @spec new(client :: Client.t()) :: Req.Request.t()
  def new(client \\ %Client{}) do
    Req.new(
      base_url: base_url(client.environment),
      auth: {:basic, api_key()},
      headers: [{"Accept", "application/json"}]
    )
  end

  @impl true
  @doc """
  Sends a HTTP DELETE request to the given `path`.
  """
  @spec delete(path :: nonempty_binary, client :: Client.t()) :: Response.t()
  def delete(path, client \\ %Client{}) do
    new(client)
    |> Req.delete(url: path)
  end

  @impl true
  @doc """
  Sends a HTTP GET request to the given `path`.
  """
  @spec get(path :: nonempty_binary, client :: Client.t()) :: Response.t()
  def get(path, client) do
    new(client)
    |> Req.get(url: path)
  end

  @impl true
  @doc """
  Sends a HTTP GET request with parameters to the given `path`.
  """
  @spec get(path :: nonempty_binary, params :: keyword(), client :: Client.t()) ::
          Response.t()
  def get(path, params, client) do
    new(client)
    |> Req.get(url: path, params: params)
  end

  @impl true
  @doc """
  Sends a HTTP POST request to the given `path`.
  """
  @spec post(path :: nonempty_binary, params :: keyword(), client :: Client.t()) ::
          Response.t()
  def post(path, params \\ [], client \\ %Client{}) do
    new(client)
    |> Req.post(url: path, params: params)
  end

  @impl true
  @doc """
  Sends a HTTP PUT request to the given `path`.
  """
  @spec put(path :: nonempty_binary, params :: keyword(), client :: Client.t()) ::
          Response.t()
  def put(path, params \\ [], client \\ %Client{}) do
    new(client)
    |> Req.put(url: path, params: params)
  end

  defp api_key do
    Config.get(:api_key) ||
      Config.raise_error("No :api_key configuration was provided or available.")
  end

  defp base_url(environment) do
    case environment do
      :live ->
        @base_live_url

      :sandbox ->
        @base_sandbox_url

      _ ->
        @base_sandbox_url
    end
  end
end
