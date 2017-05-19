defmodule PubnubEx.Subscribe do
  use GenServer
  require Logger

  import PubnubEx.Record

  def start_link(channel, pid) do
    GenServer.start_link(__MODULE__, [channel, pid])
  end

  def init([channel, pid]) do
    Process.flag(:trap_exit, true)
    config = PubnubEx.Record.create_config(channel)
    state = PubnubEx.Record.create_state(pid, config)
    {:ok, state}
  end

  def handle_cast(:start, sub_state(pid: pid, pubnub_config: pubnub_config)=state) do
    Logger.debug inspect(state)
    spawn_result = spawn_monitor(__MODULE__, :request, [pubnub_config, pid, 0])
    state = PubnubEx.Record.set_monitor_client(state, spawn_result)
    {:noreply, state}
  end
  def handle_cast(msg, state) do
    Logger.warn "Unknow handle cast event."
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, :normal}, sub_state() = state) do
    state = PubnubEx.Record.set_monitor_client(state, nil)
    {:noreply, state}
  end

  def handle_info(msg, sub_state(pid: pid) = state) do
    Logger.warn "Unknown handle info #{inspect(msg)}"
    {:noreply, state}
  end

  def start(pid) do
    GenServer.cast pid, :start
  end

  def request(pubnub_config()=config, pid, timetoken) do
    url = get_url(config, timetoken)
    Logger.debug url
    {:ok, res} = HTTPoison.get(url, [], [timeout: :infinity, recv_timeout: :infinity])
    %HTTPoison.Response{body: body, status_code: 200} = res
    Logger.debug inspect(body)
    timetoken = Poison.decode!(body)
    request(config, pid, timetoken)
  end

  defp get_url(pubnub_config(origin: origin, subkey: subkey, channel: channel)=config, timetoken) do
    schema = get_schema(config)
    schema <> "://" <> origin <> "/subscribe/" <> subkey <> "/" <> channel <> "/0/" <> to_string(timetoken)
  end
  defp get_schema(pubnub_config(ssl: true)= config), do: "https"
  defp get_schema(pubnub_config(ssl: false)= config), do: "http"
end
