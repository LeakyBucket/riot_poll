defmodule RiotPoll.HTTP.RiotApiTest do
  use ExUnit.Case

  alias RiotPoll.HTTP.Data.Summoner
  alias RiotPoll.HTTP.RiotApi

  import Mox

  setup :verify_on_exit!

  describe "get_summoner_by_name/2" do
    test "returns {:ok, Summoner.t()} for a valid name and region" do
      expect(RiotClientBehaviourMock, :get_summoner_by_name, fn name, _region ->
        {:ok,
         %Req.Response{
           body: %{
             "accountId" => "randomid",
             "profileIconId" => 8,
             "revisionDate" => 386_386_368_368,
             "name" => name,
             "id" => "38385ghd",
             "puuid" => "38s84-4848-837",
             "summonerLevel" => 8
           }
         }}
      end)

      assert {:ok, %Summoner{name: "Chucky"}} = RiotApi.get_summoner_by_name("Chucky", "la2")
    end

    test "returns an error when given an invalid region" do
      bogus_region = "bogus"

      assert {:error, "Invalid region: #{bogus_region}"} ==
               RiotApi.get_summoner_by_name("Chucky", bogus_region)
    end

    test "returns an error tuple with response body on HTTP error" do
      expect(RiotClientBehaviourMock, :get_summoner_by_name, fn _name, _region ->
        {:error,
         %Req.Response{
           body: "Not Found"
         }}
      end)

      assert {:error, "Not Found"} == RiotApi.get_summoner_by_name("Missing", "la2")
    end
  end

  describe "get_summoner_by_puuid/2" do
    test "returns {:ok, Summoner.t()} for a valid name and region" do
      expect(RiotClientBehaviourMock, :get_summoner_by_puuid, fn puuid, _region ->
        {:ok,
         %Req.Response{
           body: %{
             "accountId" => "randomid",
             "profileIconId" => 8,
             "revisionDate" => 386_386_368_368,
             "name" => "Chuky",
             "id" => "38385ghd",
             "puuid" => puuid,
             "summonerLevel" => 8
           }
         }}
      end)

      assert {:ok, %Summoner{puuid: "83563-35623"}} =
               RiotApi.get_summoner_by_puuid("83563-35623", "la2")
    end

    test "returns an error when given an invalid region" do
      bogus_region = "bogus"

      assert {:error, "Invalid region: #{bogus_region}"} ==
               RiotApi.get_summoner_by_puuid("Chucky", bogus_region)
    end

    test "returns an error tuple with response body on HTTP error" do
      expect(RiotClientBehaviourMock, :get_summoner_by_puuid, fn _name, _region ->
        {:error,
         %Req.Response{
           body: "Not Found"
         }}
      end)

      assert {:error, "Not Found"} == RiotApi.get_summoner_by_puuid("Missing", "la2")
    end
  end

  describe "get_recent_match_ids/2" do
    test "returns {:ok, list(String.t())} for for a valid summoner and region" do
      name = "Chucky"

      summoner = %Summoner{
        account_id: "3853865",
        profile_icon_id: 8,
        revision_date: 88,
        name: name,
        id: "random",
        puuid: "double-random",
        summoner_level: 1
      }

      expect(RiotClientBehaviourMock, :get_recent_match_ids, fn summoner, _region ->
        assert summoner.name == name

        {:ok,
         %Req.Response{
           body: [
             "BR1_2775325873",
             "BR1_2775325863",
             "BR1_2775322863",
             "BR1_2775325823",
             "BR1_2775725863"
           ]
         }}
      end)

      assert {:ok,
              [
                "BR1_2775325873",
                "BR1_2775325863",
                "BR1_2775322863",
                "BR1_2775325823",
                "BR1_2775725863"
              ]} == RiotApi.get_recent_match_ids(summoner, "br1")
    end

    test "returns the body from HTTP error" do
      expect(RiotClientBehaviourMock, :get_recent_match_ids, fn _summoner, _region ->
        {:error, %Req.Response{body: "Internal Server Error"}}
      end)

      assert {:error, "Internal Server Error"} == RiotApi.get_recent_match_ids(%Summoner{}, "la2")
    end
  end

  describe "get_match_participants/2" do
    test "returns {:ok, list(String.t())} for a valid match id and region" do
      expect(RiotClientBehaviourMock, :get_match_participants, fn _match_id, _region ->
        {:ok,
         %Req.Response{
           body: %{
             "metadata" => %{
               "dataVersion" => "clang",
               "matchId" => "3863ghat93",
               "participants" => [
                 "6IgOOwuhMIvWrrtHiWtGkPFnE62oseB5Ns1s6iU6UsFb_rUKOwKvLOj-bcpgdrYrHORxOh1pTcDw9g",
                 "AVx5zN3WVkLRGJOnNZjrERiMOztECu9CIvVU8d9yVHw8dkuS32n-aww7vmXoS0y7Yi9HM9XQy008nQ",
                 "pCKQJSzdhlpfGcZ3sje27RQRqQU7-SQIhhkadWO7WhRFJgSaIbDEUg3kwRyEFCX4Y-KX6cpz4LZ0MA",
                 "DIuGqAZkNsOOtglH6GiuvYLaxToALe3__h0Jf-l290SCTBS9K5XeLaEtJh7yPO21zNKOAFwhW2ZROA",
                 "qImqqUOyHRwQ2ttPQk6phF1qckOR1C_CAKkVVGNvGO1Yogy-Fden5NTNY176xc9grF-gZpj6Q6mThA",
                 "PLf0ll4miOXP2yi0GdrkRuIJeYciekrRCicDemV3oS0tOpYWH1xSPWOB9njnj1JIdVSCY4uT5U5-0g",
                 "zXQh053UqT4ITPbRKUXwCX64znaNNowCwRWoR45f9fQ7vYjFBKYDL9lUYv88Osju0Tk40KnEHY9k3g",
                 "kIKvVUK_kq-PJkNcGXOMGsc4vSXo2Op7jCC7aNExRJDlaEyxVa9OLYugzkz3S3O_lb2bo7Nb45YdsQ"
               ]
             },
             "info" => %{}
           }
         }}
      end)

      assert {:ok,
              [
                "6IgOOwuhMIvWrrtHiWtGkPFnE62oseB5Ns1s6iU6UsFb_rUKOwKvLOj-bcpgdrYrHORxOh1pTcDw9g",
                "AVx5zN3WVkLRGJOnNZjrERiMOztECu9CIvVU8d9yVHw8dkuS32n-aww7vmXoS0y7Yi9HM9XQy008nQ",
                "pCKQJSzdhlpfGcZ3sje27RQRqQU7-SQIhhkadWO7WhRFJgSaIbDEUg3kwRyEFCX4Y-KX6cpz4LZ0MA",
                "DIuGqAZkNsOOtglH6GiuvYLaxToALe3__h0Jf-l290SCTBS9K5XeLaEtJh7yPO21zNKOAFwhW2ZROA",
                "qImqqUOyHRwQ2ttPQk6phF1qckOR1C_CAKkVVGNvGO1Yogy-Fden5NTNY176xc9grF-gZpj6Q6mThA",
                "PLf0ll4miOXP2yi0GdrkRuIJeYciekrRCicDemV3oS0tOpYWH1xSPWOB9njnj1JIdVSCY4uT5U5-0g",
                "zXQh053UqT4ITPbRKUXwCX64znaNNowCwRWoR45f9fQ7vYjFBKYDL9lUYv88Osju0Tk40KnEHY9k3g",
                "kIKvVUK_kq-PJkNcGXOMGsc4vSXo2Op7jCC7aNExRJDlaEyxVa9OLYugzkz3S3O_lb2bo7Nb45YdsQ"
              ]} == RiotApi.get_match_participants("id", "la2")
    end
  end
end
