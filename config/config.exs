import Config

config :companies_house, client: CompaniesHouse.Client.Req

if Mix.env() == :test do
  config :companies_house, client: CompaniesHouse.ClientMock
end
