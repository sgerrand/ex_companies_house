defmodule CompaniesHouseTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest CompaniesHouse

  setup :verify_on_exit!

  describe "get_company_profile/1" do
    test "returns company profile when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, client ->
        assert path == "/company/12345678"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{company_name: "Test Company Ltd"}}}
      end)

      assert {:ok, %{company_name: "Test Company Ltd"}} ==
               CompaniesHouse.get_company_profile("12345678")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _req, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} ==
               CompaniesHouse.get_company_profile("12345678")
    end
  end

  describe "get_registered_office_address/1" do
    test "returns company profile when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, client ->
        assert path == "/company/12345678/registered-office-address"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             address_line_1: "123 Test Street",
             address_line_2: "",
             country: "England",
             locality: "London",
             postal_code: "CF14 3UZ",
             region: "Surrey"
           }
         }}
      end)

      assert {:ok,
              %{
                address_line_1: "123 Test Street",
                address_line_2: "",
                country: "England",
                locality: "London",
                postal_code: "CF14 3UZ",
                region: "Surrey"
              }} ==
               CompaniesHouse.get_registered_office_address("12345678")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _req, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} ==
               CompaniesHouse.get_registered_office_address("12345678")
    end
  end

  describe "list_filing_history/1" do
    test "returns list of filing history when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, _params, client ->
        assert path == "/company/12345678/filing-history"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             items: [
               %{
                 category: "some category",
                 date: "some date",
                 description: "some description",
                 type: "some type"
               },
               %{
                 category: "some other category",
                 date: "some other date",
                 description: "some other description",
                 type: "some other type"
               }
             ]
           }
         }}
      end)

      assert {:ok,
              [
                %{
                  category: "some category",
                  date: "some date",
                  description: "some description",
                  type: "some type"
                },
                %{
                  category: "some other category",
                  date: "some other date",
                  description: "some other description",
                  type: "some other type"
                }
              ]} =
               CompaniesHouse.list_filing_history("12345678")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_filing_history("12345678")
    end
  end

  describe "get_filing_history/2" do
    test "returns filing history when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, client ->
        assert path == "/company/12345678/filing-history/123"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             category: "some category",
             date: "some date",
             description: "some description",
             type: "some type"
           }
         }}
      end)

      assert {:ok,
              %{
                category: "some category",
                date: "some date",
                description: "some description",
                type: "some type"
              }} ==
               CompaniesHouse.get_filing_history("12345678", "123")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_filing_history("12345678", "123")
    end
  end

  describe "list_persons_with_significant_control/3" do
    test "returns list of people with significant control when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, _params, client ->
        assert path == "/company/12345678/persons-with-significant-control"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{items: [%{name: "Jane Bloggs"}, %{name: "John Doe"}]}}}
      end)

      assert {:ok, [%{name: "Jane Bloggs"}, %{name: "John Doe"}]} =
               CompaniesHouse.list_persons_with_significant_control("12345678")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_persons_with_significant_control("12345678")
    end
  end

  describe "get_person_with_significant_control/3" do
    test "returns person with significant control when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, client ->
        assert path == "/company/12345678/persons-with-significant-control/individual/987"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{name: "Jane Bloggs"}}}
      end)

      assert {:ok, %{name: "Jane Bloggs"}} =
               CompaniesHouse.get_person_with_significant_control("12345678", "987")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_person_with_significant_control("12345678", "987")
    end
  end

  describe "list_company_officers/1" do
    test "returns list of company officers when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, _params, client ->
        assert path == "/company/12345678/officers"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{items: [%{name: "Jane Bloggs"}, %{name: "John Doe"}]}}}
      end)

      assert {:ok, [%{name: "Jane Bloggs"}, %{name: "John Doe"}]} =
               CompaniesHouse.list_company_officers("12345678")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_company_officers("12345678")
    end
  end

  describe "get_officer_appointment/2" do
    test "returns company officer when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, client ->
        assert path == "/company/12345678/appointments/123"
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{name: "John Doe", occupation: "Company Director", nationality: "British"}
         }}
      end)

      assert {:ok, %{name: "John Doe", occupation: "Company Director", nationality: "British"}} ==
               CompaniesHouse.get_officer_appointment("12345678", "123")
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_officer_appointment("12345678", "123")
    end
  end

  describe "search_companies/3" do
    test "returns search results when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, params, client ->
        assert path == "/search/companies"
        assert params == [q: "Test Company", items_per_page: 10]
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"items" => [%{"company_name" => "Test Company Ltd"}]}}}
      end)

      assert {:ok, %{"items" => [%{"company_name" => "Test Company Ltd"}]}} =
               CompaniesHouse.search_companies("Test Company", items_per_page: 10)
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.search_companies("Unknown Company")
    end

    test "handles network errors" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:error, %{reason: :timeout}}
      end)

      assert {:error, %{reason: :timeout}} =
               CompaniesHouse.search_companies("Test Company")
    end

    test "handles pagination parameters" do
      expect(CompaniesHouse.ClientMock, :get, fn path, params, _client ->
        assert path == "/search/companies"
        assert params == [q: "Test Company", items_per_page: 50, start_index: 10]

        {:ok, %{status: 200, body: %{"items" => [%{"company_name" => "Test Company Ltd"}]}}}
      end)

      assert {:ok, %{"items" => [%{"company_name" => "Test Company Ltd"}]}} =
               CompaniesHouse.search_companies("Test Company",
                 items_per_page: 50,
                 start_index: 10
               )
    end
  end

  describe "search_officers/3" do
    test "returns search results when successful" do
      expect(CompaniesHouse.ClientMock, :get, fn path, params, client ->
        assert path == "/search/officers"
        assert params == [q: "some officer", items_per_page: 10]
        assert client == %CompaniesHouse.Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"items" => [%{"company_name" => "Test Company Ltd"}]}}}
      end)

      assert {:ok, %{"items" => [%{"company_name" => "Test Company Ltd"}]}} =
               CompaniesHouse.search_officers("some officer", items_per_page: 10)
    end

    test "returns error when request fails" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Officer not found"}}}
      end)

      assert {:error, {404, %{"error" => "Officer not found"}}} =
               CompaniesHouse.search_officers("some unknown officer")
    end

    test "returns error when unknown error occurs" do
      expect(CompaniesHouse.ClientMock, :get, fn _path, _params, _client ->
        {:error, "An unknown error occurred."}
      end)

      assert {:error, "An unknown error occurred."} =
               CompaniesHouse.search_officers("some unknown officer")
    end
  end
end
