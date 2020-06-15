defmodule RainforestEagle.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :rainforest_eagle,
      version: @version,
      elixir: "~> 1.10",
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
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: :dev, runtime: false},
      # Everything else
      {:telemetry, "~> 0.4.1"},
      {:tesla, "~> 1.3.0"}
    ]
  end
end
