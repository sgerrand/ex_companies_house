# Changelog

All notable changes to this project will be documented in this file. See [Keep a
CHANGELOG](http://keepachangelog.com/) for how to update this file. This project
adheres to [Semantic Versioning](http://semver.org/).

<!-- %% CHANGELOG_ENTRIES %% -->

## [0.4.0](https://github.com/sgerrand/ex_companies_house/compare/v0.3.1...v0.4.0) (2026-06-10)


### Added

* **client:** make request retry configurable ([e818ff8](https://github.com/sgerrand/ex_companies_house/commit/e818ff84dbbbd1f811d5c059767693654f1f2f14))
* **psc:** support all PSC kinds, not just individual ([230b155](https://github.com/sgerrand/ex_companies_house/commit/230b1550b84bd91e3681b41d658c2b80c13d259e))
* **telemetry:** emit exception event when the request raises ([0ed671a](https://github.com/sgerrand/ex_companies_house/commit/0ed671af9dc989d3665c174597ebfba72f912b47))


### Fixed

* **deps:** bump req from 0.5.17 to 0.5.18 ([#94](https://github.com/sgerrand/ex_companies_house/issues/94)) ([1303e44](https://github.com/sgerrand/ex_companies_house/commit/1303e44268db09f1bee34278fdb89bc381154edf))
* **deps:** bump the elixir group with 2 updates ([#81](https://github.com/sgerrand/ex_companies_house/issues/81)) ([f57c15d](https://github.com/sgerrand/ex_companies_house/commit/f57c15d4dda13ee86ac3794909f75e747f523b43))
* move preferred_cli_env to cli/0 callback ([f63952f](https://github.com/sgerrand/ex_companies_house/commit/f63952f5d2c982b4a6782996619857f31a4637b1))
* remove unused require Req ([fa84e32](https://github.com/sgerrand/ex_companies_house/commit/fa84e3213d284f6051c62f623877e7106d3f3c3e))
* **stream:** halt pagination when a page returns empty items ([85bc28a](https://github.com/sgerrand/ex_companies_house/commit/85bc28a6a1c3989c8e4f0803a74d4e87f02551cc))
* **types:** widen Response.t and drop unused Config type ([bcd6901](https://github.com/sgerrand/ex_companies_house/commit/bcd690143f1945ca815f3193a2bd1bdd5682e01e))


### Changed

* **api:** make clear that list_* returns a single page ([544ff16](https://github.com/sgerrand/ex_companies_house/commit/544ff16f4480da6686b60f6fc02210a9d40bd550))
* **client:** source valid environments from Config ([54c5e9c](https://github.com/sgerrand/ex_companies_house/commit/54c5e9c6c6eca835026e42e34311f0940f5c933e))
* document mado as the Markdown linter ([7182b73](https://github.com/sgerrand/ex_companies_house/commit/7182b73da269f8a8f804ed4de3377aa90aab3ad1))
* document release-mate release workflow ([9a20d15](https://github.com/sgerrand/ex_companies_house/commit/9a20d158af11b5944e161483ccfe0e7933e56e83))
* **readme:** pad fenced code block with blank lines ([afb6bda](https://github.com/sgerrand/ex_companies_house/commit/afb6bda838174c8edb8065cabf41e8b9b746302c))
* simplify facade config and route through Client seam ([#92](https://github.com/sgerrand/ex_companies_house/issues/92)) ([21a4209](https://github.com/sgerrand/ex_companies_house/commit/21a42092f115b5385b1ad8452d0b345539399794))

## [0.3.1](https://github.com/sgerrand/ex_companies_house/compare/v0.3.0...v0.3.1) (2026-04-17)


### Fixed

* **test:** silence mix test warnings ([#79](https://github.com/sgerrand/ex_companies_house/issues/79)) ([017cbe9](https://github.com/sgerrand/ex_companies_house/commit/017cbe9ed7b699ea5987ea6f1df3bf31f46b0206))

## [0.3.0](https://github.com/sgerrand/ex_companies_house/compare/v0.2.1...v0.3.0) (2026-04-14)


### Added

* add charges, insolvency, exemptions, UK establishments, and officer search endpoints ([#72](https://github.com/sgerrand/ex_companies_house/issues/72)) ([6dda9dc](https://github.com/sgerrand/ex_companies_house/commit/6dda9dc3a902682297c22348827a059f0159787d))
* add stream_* functions for auto-paginating list endpoints ([#69](https://github.com/sgerrand/ex_companies_house/issues/69)) ([2edfe85](https://github.com/sgerrand/ex_companies_house/commit/2edfe857b0fb8c9c5756a174f46e3e8b9bf0c2e6))
* emit telemetry events around HTTP requests ([#70](https://github.com/sgerrand/ex_companies_house/issues/70)) ([7500cd2](https://github.com/sgerrand/ex_companies_house/commit/7500cd2e386cbab141c67fca710db0c5c9b50309))


### Fixed

* narrow Response.t error type from any() to concrete union ([#74](https://github.com/sgerrand/ex_companies_house/issues/74)) ([6771124](https://github.com/sgerrand/ex_companies_house/commit/67711248fb3e56b8216a9f4c020999f89e2b2654))
* widen Response.t() success type to include list return from list_* functions ([#75](https://github.com/sgerrand/ex_companies_house/issues/75)) ([2457d40](https://github.com/sgerrand/ex_companies_house/commit/2457d40f9598cc6025686a1383d9b461f2d324ad))


### Changed

* document list vs search return value asymmetry in moduledoc ([#73](https://github.com/sgerrand/ex_companies_house/issues/73)) ([e06d495](https://github.com/sgerrand/ex_companies_house/commit/e06d4956f86b2d51e3c965c7e05a8b8ab5b7748f))

## [0.2.1](https://github.com/sgerrand/ex_companies_house/compare/v0.2.0...v0.2.1) (2026-04-13)


### Fixed

* **ci:** use RELEASE_PLEASE_PAT to allow PR creation ([#65](https://github.com/sgerrand/ex_companies_house/issues/65)) ([5a7ae21](https://github.com/sgerrand/ex_companies_house/commit/5a7ae216bb9b860694020a1825a8d9102dd64acb))
* delegate api key retrieval to Config.api_key/0 ([#61](https://github.com/sgerrand/ex_companies_house/issues/61)) ([c07e4f1](https://github.com/sgerrand/ex_companies_house/commit/c07e4f100ad9674322cdd53d95b25d90b6706b5a))
* raise on unknown environment instead of silently using sandbox ([#62](https://github.com/sgerrand/ex_companies_house/issues/62)) ([cd583cc](https://github.com/sgerrand/ex_companies_house/commit/cd583cc092410a3d7189e9944cbb16774e387e2e))
* remove Config.put/3 ([#64](https://github.com/sgerrand/ex_companies_house/issues/64)) ([7520fdd](https://github.com/sgerrand/ex_companies_house/commit/7520fdd327c4451196fae0a6746a344f476bef6f))
* resolve http_client at compile time in CompaniesHouse module ([#63](https://github.com/sgerrand/ex_companies_house/issues/63)) ([b83b24a](https://github.com/sgerrand/ex_companies_house/commit/b83b24abf9e5fa44fb8a67ac5b77bf2d5da536fe))
* serialise tests that mutate application env ([#60](https://github.com/sgerrand/ex_companies_house/issues/60)) ([63b6c3c](https://github.com/sgerrand/ex_companies_house/commit/63b6c3c0a33bf6af472d448d6fd094260bc360bb))
* use string key when extracting items from list responses ([#59](https://github.com/sgerrand/ex_companies_house/issues/59)) ([902d390](https://github.com/sgerrand/ex_companies_house/commit/902d3906fbdac0bf657502a11cfa0f3f1be934c8))


### Changed

* document that search functions return the full response envelope ([#66](https://github.com/sgerrand/ex_companies_house/issues/66)) ([02d549b](https://github.com/sgerrand/ex_companies_house/commit/02d549b7b2efcab7d00c42a96f7af014c49da280))
* replace placeholder moduledoc with description and usage example ([#67](https://github.com/sgerrand/ex_companies_house/issues/67)) ([fa950de](https://github.com/sgerrand/ex_companies_house/commit/fa950de97b222343010fb3222eb42f0ed7a75fd5))

## 0.2.0 - 2025-04-24

### Changes\n- Introduced Client.new/0, Client.new/1 and Client.from_config/0 as ways to instantiate a new client.\n- Introduced COnfig.api_key/0 and Config.environment/0 as ways to query existing configuration.\n- Improved documentation of functions, types and the overall project.


## 0.1.0 - 2025-01-29

Initial release. :rocket:
