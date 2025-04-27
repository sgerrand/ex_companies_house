import Config

if config_env() == :test do
  config :companies_house, :http_client, CompaniesHouse.MockHTTPClient
end
