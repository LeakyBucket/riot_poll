defmodule RiotPoll.Worker.Pollster do
  @moduledoc """
  The Pollster is responsible for periodically checking on the match status of a given
  Summoner.
  """

  use GenServer

  def start_link(initial) do
    GenServer.start_link(__MODULE__, initial)
  end

  def init(initial) do
    {:ok, Keyword.merge([last_match_id: nil, iterations: iterations()], initial)}
  end

  defp interval, do: Application.fetch_env(:riot_poll, :poll_period_seconds)

  defp iterations, do: Application.fetch_env(:riot_poll, :poll_iterations)
end
