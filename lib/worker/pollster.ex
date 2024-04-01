defmodule RiotPoll.Worker.Pollster do
  @moduledoc """
  The Pollster is responsible for periodically checking on the match status of a given
  Summoner.
  """

  use GenServer

  alias RiotPoll.HTTP.RiotApi

  require Logger

  def start_link(initial) do
    GenServer.start_link(__MODULE__, initial)
  end

  @impl true
  def init(initial) do
    last_match_ids = initial.summoner |> match_ids(initial.region) |> MapSet.new()
    state = Map.merge(%{last_match_ids: last_match_ids, iterations: iterations()}, initial)

    Process.send_after(self(), :poll, interval() * 1000)

    {:ok, state}
  end

  @impl true
  def handle_info(:poll, state) do
    remaining_iterations = state.iterations - 1

    state =
      state
      |> update_match_ids()
      |> Map.put(:iterations, remaining_iterations)

    case remaining_iterations do
      0 ->
        {:stop, state}

      _ ->
        Process.send_after(self(), :poll, interval() * 1000)
        {:noreply, state}
    end
  end

  defp update_match_ids(state) do
    match_ids = state.summoner |> match_ids(state.region) |> MapSet.new()

    diff = MapSet.symmetric_difference(state.last_match_ids, match_ids)

    if MapSet.size(diff) > 0 do
      Logger.info("Summoner #{state.summoner.name} completed a match #{hd(MapSet.to_list(diff))}")
    end

    Map.put(state, :last_match_ids, match_ids)
  end

  defp match_ids(summoner, region) do
    {:ok, match_ids} = RiotApi.get_recent_match_ids(summoner, region)

    match_ids
  end

  defp interval do
    {:ok, seconds} = Application.fetch_env(:riot_poll, :poll_period_seconds)

    seconds
  end

  defp iterations do
    {:ok, iterations} = Application.fetch_env(:riot_poll, :poll_iterations)

    iterations
  end
end
