defmodule RiotPoll.HTTP.RiotClientBehaviour do
  @moduledoc """
  Simple behavior to solidify the HTTP client behavior.  This
  is mainly here to facilitate unit testing.
  """

  alias RiotPoll.HTTP.Data.Summoner

  @doc """
  Callback definition for fetching a summoner by name and region
  """
  @callback get_summoner_by_name(name :: String.t(), region :: String.t()) ::
              {:error, String.t()} | {:ok, Summoner.t()}

  @doc """
  Callback definition for fetching a summoner by puuid and region
  """
  @callback get_summoner_by_puuid(puuid :: String.t(), region :: String.t()) ::
              {:error, String.t()} | {:ok, Summoner.t()}

  @doc """
  Callback for fetching the most recent match ids of a summoner
  """
  @callback get_recent_match_ids(summoner :: Sumoner.t(), region :: String.t()) ::
              {:error, String.t()} | {:ok, list(String.t())}

  @doc """
  Callback for fetching participant ids from a given match
  """
  @callback get_match_participants(match_id :: String.t(), region :: String.t()) ::
              {:error, String.t()} | {:ok, list(String.t())}
end
