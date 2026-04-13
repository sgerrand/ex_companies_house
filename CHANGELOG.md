# Changelog

All notable changes to this project will be documented in this file. See [Keep a
CHANGELOG](http://keepachangelog.com/) for how to update this file. This project
adheres to [Semantic Versioning](http://semver.org/).

<!-- %% CHANGELOG_ENTRIES %% -->

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
