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

  def launch_workers(names, region) do
    Enum.each(names, fn name ->
      DynamicSupervisor.start_child(__MODULE__, {Pollster, name: name, region: region})
    end)
  end
end
