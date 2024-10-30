defmodule CompaniesHouse.Client do
  @moduledoc """
  Documentation for `CompaniesHouse.Client`.
  """

  alias CompaniesHouse.Response

  defstruct environment: :sandbox

  @typep environment :: :live | :sandbox
  @type t :: %__MODULE__{environment: environment()}

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
