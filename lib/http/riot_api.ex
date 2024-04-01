defmodule RiotPoll.HTTP.RiotApi do
  @moduledoc """
  "Context" for working with the Riot API.
  """

  alias RiotPoll.HTTP.Data.Regions
  alias RiotPoll.HTTP.Data.Summoner

  @doc """
  Retrieve a specific summoner given their name and a valid region. This function returns
  a tagged result tuple either containing an error message or a `Summoner.t()` struct.
  """
  @spec get_summoner_by_name(name :: String.t(), region :: String.t()) ::
          {:error, String.t()} | {:ok, Summoner.t()}
  def get_summoner_by_name(name, region) do
    if Regions.valid?(region) do
      case impl().get_summoner_by_name(name, region) do
        {:ok, response} -> {:ok, Summoner.from_riot(response.body)}
        {:error, response} -> {:error, response.body}
      end
    else
      {:error, "Invalid region: #{region}"}
    end
  end

  @doc """
  Retrieve a specific summoner given their name and a valid region. This function returns
  a tagged result tuple either containing an error message or a `Summoner.t()` struct.
  """
  @spec get_summoner_by_puuid(puuid :: String.t(), region :: String.t()) ::
          {:error, String.t()} | {:ok, String.t()}
  def get_summoner_by_puuid(puuid, region) do
    if Regions.valid?(region) do
      case impl().get_summoner_by_puuid(puuid, region) do
        {:ok, response} -> {:ok, Summoner.from_riot(response.body)}
        {:error, response} -> {:error, response.body}
      end
    else
      {:error, "Invalid region: #{region}"}
    end
  end

  @doc """
  Retrieve the most recent matche ids for the given summoner from the Riot API.  This
  function returns a tagged result tuple with a list of `String.t()` ids if successful
  or an error message if the request fails.
  """
  @spec get_recent_match_ids(summoner :: Summoner.t(), region :: String.t()) ::
          {:error, String.t()} | {:ok, list(String.t())}
  def get_recent_match_ids(summoner, region) do
    case impl().get_recent_match_ids(summoner, region) do
      {:ok, response} -> {:ok, Enum.take(response.body, 5)}
      {:error, response} -> {:error, response.body}
    end
  end

  @doc """
  Retrieves a list of participant `puuids` for the given match.  This function returns
  a tagged result tuple with a list of `String.t()` `puuids` if successful or an error
  message if the request fails.
  """
  @spec get_match_participants(match_id :: String.t(), region :: String.t()) ::
          {:error, String.t()} | {:ok, list(String.t())}
  def get_match_participants(match_id, region) do
    case impl().get_match_participants(match_id, region) do
      {:ok, response} -> {:ok, get_in(response.body, ["metadata", "participants"])}
      {:error, response} -> {:error, response.body}
    end
  end

  defp impl, do: Application.get_env(:riot_poll, :riot_api_client, RiotPoll.HTTP.RiotClientImpl)
end
