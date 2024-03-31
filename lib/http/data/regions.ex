defmodule RiotPoll.HTTP.Data.Regions do
  @moduledoc """
  Module for mapping/validating Riot API region values.
  """

  @regions [
    "br1",
    "eun1",
    "euw1",
    "jp1",
    "kr",
    "la1",
    "la2",
    "na1",
    "oc1",
    "ph2",
    "ru",
    "sg2",
    "th2",
    "tr1",
    "tw2",
    "vn2"
  ]

  @metaregion_map %{
    "br1" => "americas",
    "eun1" => "europe",
    "euw1" => "europe",
    "jp1" => "asia",
    "kr" => "asia",
    "la1" => "americas",
    "la2" => "americas",
    "na1" => "americas",
    "oc1" => "sea",
    "ph2" => "sea",
    "ru" => "europe",
    "sg2" => "sea",
    "th2" => "sea",
    "tr1" => "europe",
    "tw2" => "sea",
    "vn2" => "sea"
  }

  @doc """
  Lookup the "metaregion" for the given region

  ## Examples

      iex> Regions.metaregion("la2")
      "americas"

      iex> Regions.metaregion("rand")
      nil
  """
  @spec metaregion(region :: String.t()) :: nil | String.t()
  def metaregion(region) do
    Map.get(@metaregion_map, String.downcase(region))
  end

  @doc """
  Check if the given region is valid

  ## Examples

      iex> Regions.valid?("la2")
      true

      iex> Regions.valid?("rand")
      false
  """
  @spec valid?(region :: String.t()) :: boolean()
  def valid?(region), do: String.downcase(region) in @regions
end
