defmodule CompaniesHouse.Telemetry do
  @moduledoc """
  Telemetry events emitted by the Companies House client.

  ## Events

  ### `[:companies_house, :request, :start]`

  Emitted before each HTTP request.

  **Measurements:** `%{system_time: integer()}`

  **Metadata:** `%{method: atom(), path: String.t(), environment: :live | :sandbox}`

  ### `[:companies_house, :request, :stop]`

  Emitted after a completed HTTP request (including non-2xx responses).

  **Measurements:** `%{duration: integer()}`

  **Metadata:** `%{method: atom(), path: String.t(), environment: :live | :sandbox, status: pos_integer()}`

  ### `[:companies_house, :request, :exception]`

  Emitted when the HTTP request encounters a transport error (e.g. connection
  refused, timeout, DNS failure).

  **Measurements:** `%{duration: integer()}`

  **Metadata:** `%{method: atom(), path: String.t(), environment: :live | :sandbox, kind: :error, reason: term()}`

  ## Attaching handlers

  Use `:telemetry.attach/4` or `:telemetry.attach_many/4`:

      :telemetry.attach_many(
        "my-app-companies-house",
        [
          [:companies_house, :request, :start],
          [:companies_house, :request, :stop],
          [:companies_house, :request, :exception]
        ],
        fn event, measurements, metadata, _config ->
          IO.inspect({event, measurements, metadata})
        end,
        nil
      )

  Durations are in native time units. Convert to milliseconds with
  `System.convert_time_unit(duration, :native, :millisecond)`.
  """
end
