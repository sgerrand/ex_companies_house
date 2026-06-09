defmodule CompaniesHouse.Client.Req do
  @moduledoc """
  Documentation for `CompaniesHouse.Client.Req`.
  """

  @behaviour CompaniesHouse.Client

  alias CompaniesHouse.Client
  alias CompaniesHouse.Config
  alias CompaniesHouse.Response

  @base_live_url "https://api.company-information.service.gov.uk"
  @base_sandbox_url "https://api-sandbox.company-information.service.gov.uk"

  @doc """
  Creates a new client for interacting with the Companies House API.

  Retry behaviour is read from the `:retry` application key and passed
  straight to `Req` (see `Req.request/1`). It defaults to `false` (no
  retries). Set it to enable resilience against transient failures and
  rate limiting — `Req`'s `:safe_transient` honours `Retry-After` on `429`
  and `503` responses:

      config :companies_house, retry: :safe_transient
  """
  @spec new(client :: Client.t()) :: Req.Request.t()
  def new(client \\ %Client{}) do
    Req.new(
      base_url: base_url(client.environment),
      auth: {:basic, Config.api_key()},
      headers: [{"Accept", "application/json"}],
      retry: Config.get(:retry, false)
    )
  end

  @impl true
  @doc """
  Sends a HTTP GET request to the given `path`.
  """
  @spec get(path :: nonempty_binary, client :: Client.t()) :: Response.t()
  def get(path, client) do
    with_telemetry(:get, path, client, fn ->
      new(client) |> Req.get(url: path)
    end)
  end

  @impl true
  @doc """
  Sends a HTTP GET request with parameters to the given `path`.
  """
  @spec get(path :: nonempty_binary, params :: keyword(), client :: Client.t()) ::
          Response.t()
  def get(path, params, client) do
    with_telemetry(:get, path, client, fn ->
      new(client) |> Req.get(url: path, params: params)
    end)
  end

  defp base_url(:live), do: @base_live_url
  defp base_url(:sandbox), do: @base_sandbox_url

  defp base_url(env),
    do: raise(ArgumentError, "Unknown environment: #{inspect(env)}")

  defp with_telemetry(method, path, client, fun) do
    metadata = %{method: method, path: path, environment: client.environment}
    start = System.monotonic_time()

    :telemetry.execute(
      [:companies_house, :request, :start],
      %{system_time: System.system_time()},
      metadata
    )

    try do
      result = fun.()

      case result do
        {:ok, response} ->
          :telemetry.execute(
            [:companies_house, :request, :stop],
            %{duration: System.monotonic_time() - start},
            Map.put(metadata, :status, response.status)
          )

        {:error, reason} ->
          :telemetry.execute(
            [:companies_house, :request, :exception],
            %{duration: System.monotonic_time() - start},
            Map.merge(metadata, %{kind: :error, reason: reason})
          )
      end

      result
    rescue
      exception ->
        :telemetry.execute(
          [:companies_house, :request, :exception],
          %{duration: System.monotonic_time() - start},
          Map.merge(metadata, %{kind: :error, reason: exception})
        )

        reraise exception, __STACKTRACE__
    end
  end
end
