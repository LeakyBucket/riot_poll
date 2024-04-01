defmodule RiotPoll.Worker.Supervisor do
  @moduledoc """
  Dynamic Supervisor for managing the Pollsters which check on summoner match status.
  """

  use DynamicSupervisor

  alias RiotPoll.Worker.Pollster

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def launch_workers(summoners, region) do
    Enum.each(summoners, fn summoner ->
      DynamicSupervisor.start_child(__MODULE__, {Pollster, %{summoner: summoner, region: region}})
    end)
  end
end
