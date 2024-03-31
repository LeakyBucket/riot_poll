defmodule RiotPoll.HTTP.Data.Summoner do
  @moduledoc """
  A small struct for handling Summoner data.
  """

  @type t :: %__MODULE__{
          account_id: String.t(),
          profile_icon_id: pos_integer(),
          revision_date: pos_integer(),
          name: String.t(),
          id: String.t(),
          puuid: String.t(),
          summoner_level: pos_integer()
        }

  defstruct [:account_id, :profile_icon_id, :revision_date, :name, :id, :puuid, :summoner_level]

  @doc """
  Create a new `__MODULE__.t()` from an API Response
  """
  @spec from_riot(response :: map()) :: __MODULE__.t()
  def from_riot(response) do
    Enum.reduce(response, %__MODULE__{}, fn
      {"accountId", value}, summoner -> Map.put(summoner, :account_id, value)
      {"profileIconId", value}, summoner -> Map.put(summoner, :profile_icon_id, value)
      {"revisionDate", value}, summoner -> Map.put(summoner, :revision_date, value)
      {"name", value}, summoner -> Map.put(summoner, :name, value)
      {"id", value}, summoner -> Map.put(summoner, :id, value)
      {"puuid", value}, summoner -> Map.put(summoner, :puuid, value)
      {"summonerLevel", value}, summoner -> Map.put(summoner, :summoner_level, value)
      {_key, _value}, summoner -> summoner
    end)
  end
end
