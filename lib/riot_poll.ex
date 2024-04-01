defmodule RiotPoll do
  use Application

  alias RiotPoll.HTTP.RiotApi
  alias RiotPoll.Worker

  def start(_type, _args) do
    ensure_env()

    children = [
      {Worker.Supervisor, name: PollsterSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @doc """
  Returns a list of all the **other** summoners the given summoner has played with
  in their last 5 matches and launches workers to notify when those summoners complete
  a new match.
  """
  @spec run(summoner_name :: String.t(), region :: String.t()) :: list(String.t())
  def run(summoner_name, region) do
    {:ok, summoner} = RiotApi.get_summoner_by_name(summoner_name, region)
    {:ok, match_ids} = RiotApi.get_recent_match_ids(summoner, region)

    other_summoners = get_other_summoners(match_ids, summoner, region)

    Worker.Supervisor.launch_workers(other_summoners, region)

    Enum.map(other_summoners, & &1.name)
  end

  # Fetch "other" summoners from the given match ids.  This function will filter
  # out the given summoner from the list.
  defp get_other_summoners([], _summoner, _region) do
    []
  end

  defp get_other_summoners(match_ids, summoner, region) do
    match_ids
    |> Enum.flat_map(fn id ->
      {:ok, puuids} = RiotApi.get_match_participants(id, region)

      puuids || []
    end)
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.reject(&(&1 == summoner.puuid))
    |> Enum.map(fn other ->
      {:ok, summoner} = RiotApi.get_summoner_by_puuid(other, region)
      summoner
    end)
  end

  defp ensure_env do
    ensure_poll_period_seconds()
    ensure_poll_iterations()
  end

  defp ensure_poll_iterations do
    if Application.fetch_env(:riot_poll, :poll_iterations) == :error do
      Application.put_env(:riot_poll, :poll_iterations, 60)
    end
  end

  defp ensure_poll_period_seconds do
    if Application.fetch_env(:riot_poll, :poll_interval_seconds) == :error do
      Application.put_env(:riot_poll, :poll_period_seconds, 60)
    end
  end
end
