defmodule RainforestEagle.Server do
  @doc """
    :telemetry.attach("unique-name", [:sensor, :rainforest_eagle, :read], &IO.inspect/4, nil)
  """
  use GenServer
  require Logger

  @name __MODULE__
  @interval 2 * 60 * 1000

  def start_link(_),
    do: GenServer.start_link(__MODULE__, %{last_value: 0}, name: @name)

  @impl true
  def init(state) do
    Logger.info("#{__MODULE__} starting")
    schedule_refresh()
    {:ok, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    schedule_refresh()

    reading =
      RainforestEagle.mac_id()
      |> RainforestEagle.current_summation()
      |> RainforestEagle.get_usage()

    Logger.info("#{__MODULE__} reading #{reading}")
    :telemetry.execute([:sensor, :rainforest_eagle, :read], %{usage: reading}, %{})
    {:noreply, %{state | last_value: reading}}
  end

  defp schedule_refresh, do: Process.send_after(self(), :refresh, @interval)
end
