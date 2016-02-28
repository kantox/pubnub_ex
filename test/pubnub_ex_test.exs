defmodule PubnubExTest do
  use ExUnit.Case, async: true
  doctest PubnubEx

  @channel "demo-channel"

  test "create_config returns an PubnubEx config record." do
    import PubnubEx.Record

    config = PubnubEx.Record.create_config(@channel)

    assert pubnub_config(config, :origin) == Application.get_env :pubnub_ex, :origin
    assert pubnub_config(config, :pubkey) == Application.get_env :pubnub_ex, :pubkey
    assert pubnub_config(config, :subkey) == Application.get_env :pubnub_ex, :subkey
    assert pubnub_config(config, :ssl) == Application.get_env :pubnub_ex, :ssl
    assert pubnub_config(config, :channel) == @channel
  end

  test "Success. subscribe topic and publish message." do
    ret = PubnubEx.subscribe(@channel, self())
    assert {:subscribe_pid, _pid} = ret

    receive do
      {:subscribed, @channel, _timetoken} ->
        {:ok, _timestamp} = PubnubEx.publish(@channel, JSX.encode!([text: "Hello world!"]))

        receive do
          received_message ->
            assert %{"text" => "Hello world!"} = received_message
        after
          1000 ->
            raise "No receive message."
        end
    end
  end
end
