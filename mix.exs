defmodule RainforestEagle.MixProject do
  use Mix.Project

  @version "0.4.0"

  def project do
    [
      app: :rainforest_eagle,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dev only
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      # Everything else
      {:telemetry, "~> 0.4"},
      {:telemetry_poller, "~> 0.5.0"},
      {:tesla, "~> 1.4"}
    ]
  end
end
