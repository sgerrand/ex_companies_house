defmodule CompaniesHouse.MixProject do
  use Mix.Project

  @repo_url "https://github.com/sgerrand/ex_companies_house"
  @version "0.1.0"

  def project do
    [
      app: :companies_house,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),

      # Hex
      package: package(),
      description: "Elixir client for the Companies House API",
      homepage_url: @repo_url,
      source_url: @repo_url,

      # Docs
      name: "CompaniesHouse",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5.6"},
      {:bypass, "~> 2.1", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:expublish, "~> 2.5", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md", "LICENSE"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url,
        "Changelog" => "https://hexdocs.pm/companies_house/changelog.html"
      }
    ]
  end
end
