defmodule RiotPoll.HTTP.RiotClientImpl do
  @moduledoc """
  The HTTP Client for making requests to the Riot API.
  """

  alias RiotPoll.HTTP.Data.Regions
  alias RiotPoll.HTTP.RiotClientBehaviour

  @behaviour RiotClientBehaviour

  @match_by_id "lol/match/v5/matches"
  @recent_match_ids "lol/match/v5/matches/by-puuid"
  @summoner_by_puuid "lol/summoner/v4/summoners/by-puuid"
  @summoner_by_name "lol/summoner/v4/summoners/by-name"

  @impl true
  def get_summoner_by_name(name, region) do
    url = "https://#{region}.api.riotgames.com/#{@summoner_by_name}/#{name}"

    Req.get(base_req(), url: url)
  end

  @impl true
  def get_summoner_by_puuid(puuid, region) do
    url = "https://#{region}.api.riotgames.com/#{@summoner_by_puuid}/#{puuid}"

    Req.get(base_req(), url: url)
  end

  # Concrete implementation for the `RiotApiBehaviour.get_recent_match_ids/1` callback.
  # This implementation currently makes two **big** assumptions:
  #
  #   1. We can provide a negative start value.  This appeared to be the
  #      case when messing around in the developer "sandbox" thing they provide
  #   2. We **always** want the last 5 matches
  @impl true
  def get_recent_match_ids(summoner, region) do
    url =
      "https://#{Regions.metaregion(region)}.api.riotgames.com/#{@recent_match_ids}/#{summoner.puuid}/ids"

    Req.get(base_req(), url: url, params: [start: -5])
  end

  # Concrete implementation for the `RiotApiBehaviour.get_match_paticipants/1` callback.
  @impl true
  def get_match_participants(match_id, region) do
    url = "https://#{Regions.metaregion(region)}.api.riotgames.com/#{@match_by_id}/#{match_id}"

    Req.get(base_req(), url: url)
  end

  defp base_req do
    Req.Request.put_header(Req.new(), "X-Riot-Token", api_key())
  end

  defp api_key,
    do: Application.get_env(:riot_poll, :riot_api_token, System.get_env("RIOT_API_KEY"))
end
