defmodule RainforestEagle.Telemetry do
  require Logger

  def fetch_usage do
    case RainforestEagle.current_summation() do
      i when i <= 0 ->
        Logger.error("Got invalid result from server: #{i}, ignoring.")

      i ->
        IO.inspect(i)
        :telemetry.execute([:rainforest_eagle, :read], %{usage: i}, %{}) |> IO.inspect()
    end
  end

  def start_polling do
    :telemetry_poller.start_link(
      measurements: [{__MODULE__, :fetch_usage, []}],
      period: :timer.seconds(RainforestEagle.interval()),
      name: :rainforest_eagle
    )
  end
end
