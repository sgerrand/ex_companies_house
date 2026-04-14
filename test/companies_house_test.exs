defmodule CompaniesHouseTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest CompaniesHouse

  alias CompaniesHouse.Client
  alias CompaniesHouse.MockHTTPClient

  setup :verify_on_exit!

  describe "get_company_profile/1" do
    test "returns company profile when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678"
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{company_name: "Test Company Ltd"}}}
      end)

      assert {:ok, %{company_name: "Test Company Ltd"}} ==
               CompaniesHouse.get_company_profile("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _req, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} ==
               CompaniesHouse.get_company_profile("12345678")
    end
  end

  describe "get_registered_office_address/1" do
    test "returns company profile when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/registered-office-address"
        assert client == %Client{environment: :sandbox}

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
      expect(MockHTTPClient, :get, fn _req, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} ==
               CompaniesHouse.get_registered_office_address("12345678")
    end

    test "handles network errors" do
      expect(MockHTTPClient, :get, fn _req, _client ->
        {:error, %{reason: :timeout}}
      end)

      assert {:error, %{reason: :timeout}} ==
               CompaniesHouse.get_registered_office_address("12345678")
    end
  end

  describe "list_filing_history/1" do
    test "returns list of filing history when successful" do
      expect(MockHTTPClient, :get, fn path, _params, client ->
        assert path == "/company/12345678/filing-history"
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [
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
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_filing_history("12345678")
    end
  end

  describe "get_filing_history/2" do
    test "returns filing history when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/filing-history/123"
        assert client == %Client{environment: :sandbox}

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
      expect(MockHTTPClient, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_filing_history("12345678", "123")
    end
  end

  describe "list_persons_with_significant_control/3" do
    test "returns list of people with significant control when successful" do
      expect(MockHTTPClient, :get, fn path, _params, client ->
        assert path == "/company/12345678/persons-with-significant-control"
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"items" => [%{name: "Jane Bloggs"}, %{name: "John Doe"}]}}}
      end)

      assert {:ok, [%{name: "Jane Bloggs"}, %{name: "John Doe"}]} =
               CompaniesHouse.list_persons_with_significant_control("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_persons_with_significant_control("12345678")
    end
  end

  describe "get_person_with_significant_control/3" do
    test "returns person with significant control when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/persons-with-significant-control/individual/987"
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{name: "Jane Bloggs"}}}
      end)

      assert {:ok, %{name: "Jane Bloggs"}} =
               CompaniesHouse.get_person_with_significant_control("12345678", "987")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_person_with_significant_control("12345678", "987")
    end
  end

  describe "list_company_officers/1" do
    test "returns list of company officers when successful" do
      expect(MockHTTPClient, :get, fn path, _params, client ->
        assert path == "/company/12345678/officers"
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"items" => [%{name: "Jane Bloggs"}, %{name: "John Doe"}]}}}
      end)

      assert {:ok, [%{name: "Jane Bloggs"}, %{name: "John Doe"}]} =
               CompaniesHouse.list_company_officers("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_company_officers("12345678")
    end
  end

  describe "get_officer_appointment/2" do
    test "returns company officer when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/appointments/123"
        assert client == %Client{environment: :sandbox}

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
      expect(MockHTTPClient, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_officer_appointment("12345678", "123")
    end
  end

  describe "stream_company_officers/3" do
    test "streams all officers across multiple pages" do
      expect(MockHTTPClient, :get, fn path, params, client ->
        assert path == "/company/12345678/officers"
        assert params[:start_index] == 0
        assert params[:items_per_page] == 100
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"name" => "Officer A"}, %{"name" => "Officer B"}],
             "total_results" => 3
           }
         }}
      end)

      expect(MockHTTPClient, :get, fn path, params, _client ->
        assert path == "/company/12345678/officers"
        assert params[:start_index] == 2
        assert params[:items_per_page] == 100

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"name" => "Officer C"}],
             "total_results" => 3
           }
         }}
      end)

      result = CompaniesHouse.stream_company_officers("12345678") |> Enum.to_list()

      assert result == [
               %{"name" => "Officer A"},
               %{"name" => "Officer B"},
               %{"name" => "Officer C"}
             ]
    end

    test "streams all officers when total_results is absent" do
      expect(MockHTTPClient, :get, fn _path, params, _client ->
        assert params[:start_index] == 0

        {:ok,
         %{
           status: 200,
           body: %{"items" => [%{"name" => "Officer A"}]}
         }}
      end)

      result = CompaniesHouse.stream_company_officers("12345678") |> Enum.to_list()
      assert result == [%{"name" => "Officer A"}]
    end

    test "stops stream on API error" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      result = CompaniesHouse.stream_company_officers("12345678") |> Enum.to_list()
      assert result == []
    end

    test "merges caller-supplied params" do
      expect(MockHTTPClient, :get, fn path, params, _client ->
        assert path == "/company/12345678/officers"
        assert params[:register_view] == "directors"
        assert params[:items_per_page] == 100

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"name" => "Director A"}],
             "total_results" => 1
           }
         }}
      end)

      result =
        CompaniesHouse.stream_company_officers("12345678", register_view: "directors")
        |> Enum.to_list()

      assert result == [%{"name" => "Director A"}]
    end
  end

  describe "stream_filing_history/3" do
    test "streams all filing history entries across multiple pages" do
      expect(MockHTTPClient, :get, fn path, params, _client ->
        assert path == "/company/12345678/filing-history"
        assert params[:start_index] == 0
        assert params[:items_per_page] == 100

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"type" => "AA"}, %{"type" => "CS01"}],
             "total_results" => 3
           }
         }}
      end)

      expect(MockHTTPClient, :get, fn _path, params, _client ->
        assert params[:start_index] == 2

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"type" => "TM01"}],
             "total_results" => 3
           }
         }}
      end)

      result = CompaniesHouse.stream_filing_history("12345678") |> Enum.to_list()
      assert result == [%{"type" => "AA"}, %{"type" => "CS01"}, %{"type" => "TM01"}]
    end

    test "stops stream on API error" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      result = CompaniesHouse.stream_filing_history("12345678") |> Enum.to_list()
      assert result == []
    end
  end

  describe "stream_persons_with_significant_control/3" do
    test "streams all PSCs across multiple pages" do
      expect(MockHTTPClient, :get, fn path, params, _client ->
        assert path == "/company/12345678/persons-with-significant-control"
        assert params[:start_index] == 0
        assert params[:items_per_page] == 100

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"name" => "Jane Bloggs"}],
             "total_results" => 2
           }
         }}
      end)

      expect(MockHTTPClient, :get, fn _path, params, _client ->
        assert params[:start_index] == 1

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"name" => "John Doe"}],
             "total_results" => 2
           }
         }}
      end)

      result =
        CompaniesHouse.stream_persons_with_significant_control("12345678") |> Enum.to_list()

      assert result == [%{"name" => "Jane Bloggs"}, %{"name" => "John Doe"}]
    end

    test "stops stream on API error" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      result =
        CompaniesHouse.stream_persons_with_significant_control("12345678") |> Enum.to_list()

      assert result == []
    end
  end

  describe "search_companies/3" do
    test "returns search results when successful" do
      expect(MockHTTPClient, :get, fn path, params, client ->
        assert path == "/search/companies"
        assert params == [q: "Test Company", items_per_page: 10]
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"items" => [%{"company_name" => "Test Company Ltd"}]}}}
      end)

      assert {:ok, %{"items" => [%{"company_name" => "Test Company Ltd"}]}} =
               CompaniesHouse.search_companies("Test Company", items_per_page: 10)
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.search_companies("Unknown Company")
    end

    test "handles network errors" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:error, %{reason: :timeout}}
      end)

      assert {:error, %{reason: :timeout}} =
               CompaniesHouse.search_companies("Test Company")
    end

    test "handles pagination parameters" do
      expect(MockHTTPClient, :get, fn path, params, _client ->
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
      expect(MockHTTPClient, :get, fn path, params, client ->
        assert path == "/search/officers"
        assert params == [q: "some officer", items_per_page: 10]
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"items" => [%{"company_name" => "Test Company Ltd"}]}}}
      end)

      assert {:ok, %{"items" => [%{"company_name" => "Test Company Ltd"}]}} =
               CompaniesHouse.search_officers("some officer", items_per_page: 10)
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Officer not found"}}}
      end)

      assert {:error, {404, %{"error" => "Officer not found"}}} =
               CompaniesHouse.search_officers("some unknown officer")
    end

    test "returns error when unknown error occurs" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:error, "An unknown error occurred."}
      end)

      assert {:error, "An unknown error occurred."} =
               CompaniesHouse.search_officers("some unknown officer")
    end
  end

  describe "list_charges/3" do
    test "returns list of charges when successful" do
      expect(MockHTTPClient, :get, fn path, _params, client ->
        assert path == "/company/12345678/charges"
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{"items" => [%{"charge_number" => 1}, %{"charge_number" => 2}]}
         }}
      end)

      assert {:ok, [%{"charge_number" => 1}, %{"charge_number" => 2}]} =
               CompaniesHouse.list_charges("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_charges("12345678")
    end
  end

  describe "get_charge/3" do
    test "returns charge when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/charges/abc123"
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"charge_number" => 1, "status" => "outstanding"}}}
      end)

      assert {:ok, %{"charge_number" => 1, "status" => "outstanding"}} =
               CompaniesHouse.get_charge("12345678", "abc123")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Charge not found"}}}
      end)

      assert {:error, {404, %{"error" => "Charge not found"}}} =
               CompaniesHouse.get_charge("12345678", "abc123")
    end
  end

  describe "get_insolvency/2" do
    test "returns insolvency details when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/insolvency"
        assert client == %Client{environment: :sandbox}

        {:ok, %{status: 200, body: %{"cases" => [%{"type" => "administration"}]}}}
      end)

      assert {:ok, %{"cases" => [%{"type" => "administration"}]}} =
               CompaniesHouse.get_insolvency("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_insolvency("12345678")
    end
  end

  describe "get_exemptions/2" do
    test "returns exemptions when successful" do
      expect(MockHTTPClient, :get, fn path, client ->
        assert path == "/company/12345678/exemptions"
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{"exemptions" => %{"psc_exempt_as_trading_on_uk_regulated_market" => %{}}}
         }}
      end)

      assert {:ok, %{"exemptions" => %{"psc_exempt_as_trading_on_uk_regulated_market" => %{}}}} =
               CompaniesHouse.get_exemptions("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.get_exemptions("12345678")
    end
  end

  describe "list_uk_establishments/3" do
    test "returns list of UK establishments when successful" do
      expect(MockHTTPClient, :get, fn path, _params, client ->
        assert path == "/company/12345678/uk-establishments"
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"company_number" => "BR000001"}, %{"company_number" => "BR000002"}]
           }
         }}
      end)

      assert {:ok, [%{"company_number" => "BR000001"}, %{"company_number" => "BR000002"}]} =
               CompaniesHouse.list_uk_establishments("12345678")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} =
               CompaniesHouse.list_uk_establishments("12345678")
    end
  end

  describe "list_officer_appointments/3" do
    test "returns list of officer appointments when successful" do
      expect(MockHTTPClient, :get, fn path, _params, client ->
        assert path == "/officers/officer123/appointments"
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{"items" => [%{"appointed_to" => %{"company_number" => "12345678"}}]}
         }}
      end)

      assert {:ok, [%{"appointed_to" => %{"company_number" => "12345678"}}]} =
               CompaniesHouse.list_officer_appointments("officer123")
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Officer not found"}}}
      end)

      assert {:error, {404, %{"error" => "Officer not found"}}} =
               CompaniesHouse.list_officer_appointments("officer123")
    end
  end

  describe "search_disqualified_officers/3" do
    test "returns search results when successful" do
      expect(MockHTTPClient, :get, fn path, params, client ->
        assert path == "/search/disqualified-officers"
        assert params == [q: "John Doe", items_per_page: 10]
        assert client == %Client{environment: :sandbox}

        {:ok,
         %{
           status: 200,
           body: %{
             "items" => [%{"name" => "John Doe"}],
             "total_results" => 1,
             "start_index" => 0
           }
         }}
      end)

      assert {:ok,
              %{
                "items" => [%{"name" => "John Doe"}],
                "total_results" => 1,
                "start_index" => 0
              }} =
               CompaniesHouse.search_disqualified_officers("John Doe", items_per_page: 10)
    end

    test "returns error when request fails" do
      expect(MockHTTPClient, :get, fn _path, _params, _client ->
        {:ok, %{status: 404, body: %{"error" => "Officer not found"}}}
      end)

      assert {:error, {404, %{"error" => "Officer not found"}}} =
               CompaniesHouse.search_disqualified_officers("Unknown Person")
    end
  end
end
