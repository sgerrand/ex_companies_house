defmodule CompaniesHouse.Config do
  @moduledoc """
  Methods to parse and modify configurations.
  """

  defmodule ConfigError do
    defexception [:message]
  end

  @type t :: Keyword.t()

  @valid_environments [:sandbox, :live]

  @doc """
  Gets the key value from the environment config.
  """
  @spec get(atom(), any()) :: any()
  def get(key, default \\ nil) do
    :companies_house
    |> Application.get_all_env()
    |> Keyword.get(key, default)
  end

  @doc """
  Puts a new key value to the configuration.
  """
  @spec put(t(), atom(), any()) :: t()
  def put(config, key, value) do
    Keyword.put(config, key, value)
  end

  @doc """
  Raise a ConfigError exception.
  """
  @spec raise_error(binary()) :: no_return
  def raise_error(message) do
    raise ConfigError, message: message
  end

  @doc """
  Gets the API key from configuration.
  Raises ConfigError if API key is not configured.
  """
  @spec api_key() :: String.t()
  def api_key do
    case get(:api_key) do
      nil -> raise_error("API key not found in configuration")
      key -> key
    end
  end

  @doc """
  Gets the environment from configuration.
  Default is :sandbox if not explicitly configured.
  Raises ConfigError if environment is invalid.
  """
  @spec environment() :: :sandbox | :live
  def environment do
    env = get(:environment, :sandbox)

    if env in @valid_environments do
      env
    else
      raise_error(
        "Invalid environment: #{inspect(env)}. Must be one of: #{inspect(@valid_environments)}"
      )
    end
  end
end
