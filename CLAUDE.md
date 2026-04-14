# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development

### Setup

```shell
bin/setup   # installs Homebrew tools and activates Lefthook pre-commit hooks
mix setup   # fetches Elixir dependencies
```

`bin/setup` requires [Homebrew](https://brew.sh) and installs: `actionlint`, `check-jsonschema`, `lefthook`, `markdownlint-cli2`.

### Commands

- Run all tests: `mix test`
- Run single test: `mix test path/to/test_file.exs:line_number`
- Run specific test file: `mix test path/to/test_file.exs`
- Lint: `mix credo`
- Format: `mix format`
- Test coverage: `mix coveralls`

### Pre-commit hooks (Lefthook)

Activated by `bin/setup`. Hooks run in parallel on staged files:

- `mix-format` — checks `*.{ex,exs}` are formatted
- `actionlint` — lints GitHub Actions workflow files
- `check-github-workflows` — validates workflow files against JSON schema
- `check-dependabot` — validates `.github/dependabot.yml` against JSON schema
- `check-release-please-config` — validates `release-please-config.json`
- `check-release-please-manifest` — validates `.release-please-manifest.json`
- `markdownlint` — lints `*.md` files (config in `.markdownlint-cli2.jsonc`)

## Architecture

This is an Elixir HTTP client library for the [Companies House API](https://developer-specs.company-information.service.gov.uk/) (UK government company data). It is structured in layers:

```text
CompaniesHouse           ← Public API (20 functions: get_, list_, search_, stream_)
    ↓
CompaniesHouse.Client    ← Behaviour + struct (environment: :sandbox | :live)
    ↓
CompaniesHouse.Client.Req ← Req-based HTTP implementation
```

**`CompaniesHouse`** is the main facade. All public functions accept optional `params` and `client` keyword args, defaulting to `%Client{}` (sandbox environment).

**`CompaniesHouse.Client`** defines the HTTP behaviour (`get/3`, `post/3`, etc.) and the client struct. The concrete implementation is selected via application config (`config :companies_house, :http_client, ...`), which allows tests to swap in a Mox mock.

**`CompaniesHouse.Client.Req`** builds the Req request with Basic Auth (API key from config), routes to sandbox or live base URL, and normalises responses: 200–299 → `{:ok, body}`, others → `{:error, {status, body}}`.

**`CompaniesHouse.Config`** reads `:api_key` and `:environment` from application config, raising `ConfigError` for missing or invalid values.

## Testing

Tests use **Mox** for unit tests (mock the `Client` behaviour) and **Bypass** for integration tests against `Client.Req` (real HTTP against a local server). The mock is configured in `config/config.exs` for the test environment.

- Tests that mutate application env must use `async: false`.
- List endpoints extract the `items` key automatically; tests should reflect this.
- `CompaniesHouse.Response` is excluded from coverage (it's a type-only module).

## Conventions

- Environments: `:sandbox` (default, safe) and `:live`.
- Non-200 HTTP responses surface as `{:error, {status_code, body}}`; network/transport failures surface as `{:error, exception}`. Both shapes are captured by `Response.error()`.
- List endpoints return `{:ok, [item]}` by extracting `body["items"]`.
- Search endpoints return `{:ok, map()}` with the full response envelope (pagination fields included alongside `"items"`).
- `stream_*` functions return `Enumerable.t()` (a lazy `Stream`), not `Response.t()`. They auto-paginate at 100 items per page and stop silently on API error.
- No Ecto—don't add it. Data is plain maps from JSON responses.
- All public functions have `@doc`, `@spec`, and doctests where applicable.

At the end of every change, update CLAUDE.md with anything useful that would have been helpful at the start.
