defmodule RiotPoll.Worker.PollsterTest do
  use ExUnit.Case, async: false

  import Mox

  alias RiotPoll.HTTP.Data.Summoner
  alias RiotPoll.Worker.Pollster

  setup :verify_on_exit!
  setup :set_mox_global

  describe "handle_info/2" do
    setup do
      summoner = %Summoner{
        account_id: "3853865",
        profile_icon_id: 8,
        revision_date: 88,
        name: "Bob",
        id: "random",
        puuid: "double-random",
        summoner_level: 1
      }

      {:ok, %{summoner: summoner}}
    end

    test "it checks the match status for the summoner when receiving `:poll`", %{
      summoner: watching
    } do
      expect(RiotClientBehaviourMock, :get_recent_match_ids, fn _summoner, _region ->
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

      Application.put_env(:riot_poll, :poll_iterations, 1)
      Application.put_env(:riot_poll, :poll_interval_seconds, 2)

      GenServer.start_link(Pollster, %{summoner: watching, region: "la1"})

      Process.sleep(3000)
    end

    test "it stops when iterations are complete", %{summoner: watching} do
      stub(RiotClientBehaviourMock, :get_recent_match_ids, fn _summoner, _region ->
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

      Application.put_env(:riot_poll, :poll_iterations, 1)
      Application.put_env(:riot_poll, :poll_interval_seconds, 3)

      {:ok, pid} = GenServer.start_link(Pollster, %{summoner: watching, region: "la1"})

      Process.send(pid, :poll, [])
      Process.send(pid, :poll, [])

      Process.sleep(1000)

      refute Process.alive?(pid)
    end
  end
end
