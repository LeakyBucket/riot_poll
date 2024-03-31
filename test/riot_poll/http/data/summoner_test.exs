defmodule RiotPoll.HTTP.Data.SummonerTest do
  use ExUnit.Case

  alias RiotPoll.HTTP.Data.Summoner

  describe "from_riot/1" do
    setup do
      response = %{
        "accountId" => "3386843868",
        "profileIconId" => 3337,
        "revisionDate" => 386_396_835,
        "name" => "Bob",
        "id" => "QmmG2XO9VoQzE7v0a-EWIt5r0B3-ZucTVdPduLv_6TddcjIH7DA0koJrrQ",
        "puuid" =>
          "P5XK_T-n71dx_7rp1fctZq1HPcVHkdvUazOFBAlr5AeABdkEkRyjMly3kM0D02ux_9yvbECKCv9ryg",
        "summonerLevel" => 5
      }

      {:ok, %{full_response: response}}
    end

    test "returns a `Summoner.t()` from a valid payload", %{full_response: response} do
      summoner = Summoner.from_riot(response)

      assert summoner.account_id == "3386843868"
      assert summoner.profile_icon_id == 3337
      assert summoner.revision_date == 386_396_835
      assert summoner.name == "Bob"
      assert summoner.summoner_level == 5
      assert summoner.id == "QmmG2XO9VoQzE7v0a-EWIt5r0B3-ZucTVdPduLv_6TddcjIH7DA0koJrrQ"

      assert summoner.puuid ==
               "P5XK_T-n71dx_7rp1fctZq1HPcVHkdvUazOFBAlr5AeABdkEkRyjMly3kM0D02ux_9yvbECKCv9ryg"
    end

    test "ignores unknown fields in response", %{full_response: response} do
      summoner =
        response
        |> Map.merge(%{"trunk" => "junk"})
        |> Summoner.from_riot()

      assert summoner.account_id == "3386843868"
      assert summoner.profile_icon_id == 3337
      assert summoner.revision_date == 386_396_835
      assert summoner.name == "Bob"
      assert summoner.summoner_level == 5
      assert summoner.id == "QmmG2XO9VoQzE7v0a-EWIt5r0B3-ZucTVdPduLv_6TddcjIH7DA0koJrrQ"

      assert summoner.puuid ==
               "P5XK_T-n71dx_7rp1fctZq1HPcVHkdvUazOFBAlr5AeABdkEkRyjMly3kM0D02ux_9yvbECKCv9ryg"
    end
  end
end
