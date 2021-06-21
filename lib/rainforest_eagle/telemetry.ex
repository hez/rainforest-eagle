defmodule RainforestEagle.Telemetry do
  require Logger

  def fetch_usage do
    case RainforestEagle.current_summation() do
      i when i <= 0 ->
        Logger.error("Got invalid result from server: #{i}, ignoring.")

      i ->
        :telemetry.execute([:rainforest_eagle, :read], %{usage: i}, %{})
    end
  end

  def child_config do
    {:telemetry_poller,
     measurements: [{__MODULE__, :fetch_usage, []}],
     period: :timer.seconds(RainforestEagle.interval()),
     name: :rainforest_eagle}
  end
end
