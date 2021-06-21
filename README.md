# Elixir RainforestEagle API

A limited Elixir [Rainforest Eagle API](https://rainforestautomation.com/wp-content/uploads/2015/07/EAGLE_REST_API-1.1.pdf), this has not been tested with the Eagle 200 or any other Rainforest product.

Note: Only tested on the original Eagle and currently only has been tested with the `get_current_summation` command.

## Installation

```elixir
def deps do
  [
    {:rainforest_eagle, github: "hez/rainforest-eagle", tag: "v0.2.0"}
  ]
end
```

## Usage

Config, add the following to your config/* file.

```
config :rainforest_eagle, :connection,
  mac_id: "somemac",
  host: "http://192.168.0.1",
  username: "some",
  password "auth-info",
  refresh_interval:  30 * 60 # defaults to 120 seconds

```

Code

```
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      # ...
      RainforestEagle.Telemetry.child_config()
    ]
    Supervisor.start_link(children, opts)
  end
end

defmodule MyApp.EnergyLogger do
  def log_usage([:rainforest_eagle, :read], measurements, metadata, _conf) do
    IO.puts(inspect(measurements))
  end

  def attach do
    :ok =
      :telemetry.attach(
        "telemetry-unique-name",
        [:sensor, :rainforest_eagle, :read],
        &__MODULE__.log_usage/4,
        nil
      )
  end
end
```
