ExUnit.start()

Application.put_env(:companies_house, :http_client, CompaniesHouse.ClientMock)
