# CompaniesHouse

[![Test Status](https://github.com/sgerrand/ex_companies_house/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/sgerrand/ex_companies_house/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/sgerrand/ex_companies_house/badge.svg?branch=main)](https://coveralls.io/github/sgerrand/ex_companies_house?branch=main)
[![Hex Version](https://img.shields.io/hexpm/v/companies_house.svg)](https://hex.pm/packages/companies_house)
[![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/companies_house/)

An Elixir client for the [Companies House
API](https://developer.companieshouse.gov.uk/).

## Installation

The package can be installed by adding `companies_house`
to your list of dependencies in `mix.exs`:

<!-- x-release-please-start-version -->
```elixir
def deps do
  [
    {:companies_house, "~> 0.3.0"}
  ]
end
```
<!-- x-release-please-end -->

## Usage

### Configuration

Add your API key to your application config:

```elixir
config :companies_house, api_key: "your-api-key"
```

By default the client targets the sandbox environment. To use the live API:

```elixir
config :companies_house, environment: :live
```

### Available functions

#### Company data

- `get_company_profile/2`
- `get_registered_office_address/2`
- `get_insolvency/2`
- `get_exemptions/2`

#### Officers

- `list_company_officers/3`
- `get_officer_appointment/3`
- `list_officer_appointments/3`

#### Filing history

- `list_filing_history/3`
- `get_filing_history/3`

#### Persons with significant control

- `list_persons_with_significant_control/3`
- `get_person_with_significant_control/3`

#### Charges

- `list_charges/3`
- `get_charge/3`

#### UK establishments

- `list_uk_establishments/3`

#### Search

- `search_companies/3`
- `search_officers/3`
- `search_disqualified_officers/3`

#### Streaming (auto-pagination)

- `stream_company_officers/3`
- `stream_filing_history/3`
- `stream_persons_with_significant_control/3`

### Return values

- `get_*` and `list_*` return `{:ok, map()}` or `{:ok, [map()]}` on success. Errors are either `{:error, {status_code, body}}` for non-2xx HTTP responses or `{:error, exception}` for network/transport failures (e.g. timeout, connection refused).
- `search_*` return the full response envelope (including `"total_results"` and `"start_index"`), not just the items array.
- `stream_*` return a lazy `Enumerable` that auto-paginates. Pipe into `Enum` or `Stream` functions.

See the [HexDocs](https://hexdocs.pm/companies_house/) for full API reference.

## Development

### Requirements

- Elixir (see `.tool-versions` or `mix.exs` for version)
- [Homebrew](https://brew.sh) (for installing pre-commit hook dependencies)

### Setup

```shell
bin/setup
mix setup
```

`bin/setup` installs the pre-commit hook tools (`actionlint`, `check-jsonschema`, `lefthook`, `markdownlint-cli2`) and activates the hooks. `mix setup` fetches Elixir dependencies.

### Common commands

```shell
mix test          # Run tests
mix credo         # Lint
mix format        # Format code
mix coveralls     # Test coverage
```

## License

CompaniesHouse is [released under the MIT license](LICENSE).
