defmodule PubnubEx.Publish do
  require Logger

  import PubnubEx.Record

  def publish(channel, msg) do
    config = PubnubEx.Record.create_config(channel)
    url = get_url(config, msg)
    {:ok, res} = HTTPoison.get(url, [], [timeout: :infinity, recv_timeout: :infinity])
    %HTTPoison.Response{body: body, status_code: 200} = res
    timetoken = Poison.decode!(body)
    {:ok, timetoken}
  end

  defp get_url(pubnub_config(origin: origin, pubkey: pubkey, subkey: subkey, channel: channel)=config, msg) do
    schema = get_schema(config)
    signature = "0"
    callback = "0"
    schema <> "://" <> origin <> "/publish/" <> pubkey <> "/" <>subkey <> "/" <> signature <> "/" <> channel <> "/" <> callback <> "/" <> URI.encode(msg, &URI.char_unreserved?/1)
  end
  defp get_schema(pubnub_config(ssl: true)= config), do: "https"
  defp get_schema(pubnub_config(ssl: false)= config), do: "http"
end
