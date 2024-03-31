defmodule RiotPoll do
  use Application

  @impl true
  def start(_, _) do
    import Supervisor.Spec

    ensure_env()
  end

  defp ensure_env do
    ensure_period()
    ensure_interval()
  end

  defp ensure_period do
    if Application.fetch_env(:riot_poll, :poll_period_seconds) == :error do
      Application.put_env(:riot_poll, :poll_period_seconds, 3_600)
    end
  end

  defp ensure_interval do
    if Application.fetch_env(:riot_poll, :poll_interval_seconds) == :error do
      Application.put_env(:riot_poll, :poll_period_seconds, 60)
    end
  end
end
