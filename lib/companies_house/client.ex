defmodule CompaniesHouse.Client do
  @moduledoc """
  Documentation for `CompaniesHouse.Client`.
  """

  alias CompaniesHouse.{Config, Response}

  defstruct environment: :sandbox

  @valid_environments [:live, :sandbox]
  @typep environment :: :live | :sandbox
  @type t :: %__MODULE__{environment: environment()}

  @doc """
  Creates a new client with default environment (:sandbox).
  """
  @spec new() :: t()
  def new do
    %__MODULE__{}
  end

  @doc """
  Creates a new client with specified environment.
  Raises ArgumentError if environment is invalid.
  """
  @spec new(environment()) :: t()
  def new(environment) when environment in @valid_environments do
    %__MODULE__{environment: environment}
  end

  def new(environment) do
    raise ArgumentError,
          "Invalid environment: #{inspect(environment)}. Must be one of: #{inspect(@valid_environments)}"
  end

  @doc """
  Creates a new client using application configuration.
  """
  @spec from_config() :: t()
  def from_config do
    new(Config.environment())
  end

  @impl_module Application.compile_env(:companies_house, :http_client, CompaniesHouse.Client.Req)

  @callback delete(path :: nonempty_binary(), client :: __MODULE__.t()) :: Response.t()
  defdelegate delete(path, client \\ %__MODULE__{}), to: @impl_module

  @callback get(path :: nonempty_binary(), client :: __MODULE__.t()) :: Response.t()
  defdelegate get(path, client), to: @impl_module

  @callback get(nonempty_binary(), keyword(), __MODULE__.t()) :: Response.t()
  defdelegate get(path, params, client), to: @impl_module

  @callback post(nonempty_binary(), keyword(), __MODULE__.t()) :: Response.t()
  defdelegate post(path, params \\ [], client \\ %__MODULE__{}), to: @impl_module

  @callback put(nonempty_binary(), keyword(), __MODULE__.t()) :: Response.t()
  defdelegate put(path, params \\ [], client \\ %__MODULE__{}), to: @impl_module
end
