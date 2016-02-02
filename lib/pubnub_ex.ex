defmodule PubnubEx do
  use Application

  def start(_type, _args) do
    case PubnubEx.Supervisor.start_link() do
      {:ok, pid} ->
        {:ok, pid}
      error ->
        error
    end
  end

  def stop(_state) do
    :ok
  end

  def subscribe(channel, pid) do
    {:ok, subscribe_pid} = Supervisor.start_child(PubnubEx.Supervisor, [channel, pid])
    PubnubEx.Subscribe.start(subscribe_pid)
    {:subscribe_pid, subscribe_pid}
  end

  def publish(channel, msg) do
    PubnubEx.Publish.publish(channel, msg)
  end
end
