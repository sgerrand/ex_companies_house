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
    get_env_config([], key, default)
  end

  @doc """
  Puts a new key value to the configuration.
  """
  @spec put(t(), atom(), any()) :: t()
  def put(config, key, value) do
    Keyword.put(config, key, value)
  end

  defp get_env_config(config, key, default, env_key \\ :companies_house) do
    config
    |> Keyword.get(:otp_app)
    |> case do
      nil -> Application.get_all_env(env_key)
      otp_app -> Application.get_env(otp_app, env_key, [])
    end
    |> Keyword.get(key, default)
  end

  @doc """
  Raise a ConfigError exception.
  """
  @spec raise_error(binary()) :: no_return
  def raise_error(message) do
    raise ConfigError, message: message
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
