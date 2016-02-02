defmodule PubnubEx.Record do
  import Record
  @default_origin "pubsub.pubnub.com"
  @default_pubkey "demo"
  @default_subkey "demo"
  @default_ssl    true

  defrecord :pubnub_config, channel: "",
                            origin: "", pubkey: nil, subkey: nil, ssl: true,
                            http_client: nil

  def create_config(channel) do
    origin = Application.get_env :pubnub_ex, :origin, @default_origin
    pubkey = Application.get_env :pubnub_ex, :pubkey, @default_pubkey
    subkey = Application.get_env :pubnub_ex, :subkey, @default_subkey
    ssl    = Application.get_env :pubnub_ex, :ssl, @default_ssl
    pubnub_config(origin: origin, pubkey: pubkey, subkey: subkey,
                  ssl: ssl, channel: channel)
  end

  def set_channel(pubnub_config()=config, channel) do
    pubnub_config(config, channel: channel)
  end

  def set_http_client(pubnub_config()=config, http_client) do
    pubnub_config(config, http_client: http_client)
  end

  def get_pubkey(pubnub_config(pubkey: key)), do: key

  def get_subkey(pubnub_config(subkey: key)), do: key


  defrecord :sub_state, pid: nil, monitor_client: nil, pubnub_config: nil
  def create_state(pid, pubnub_config()=config), do: sub_state(pid: pid, pubnub_config: config)

  def set_monitor_client(sub_state()=state, monitor_client) do
    sub_state(state, monitor_client: monitor_client)
  end

end
