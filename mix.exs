defmodule PubnubEx.Mixfile do
  use Mix.Project

  def project do
    [app: :pubnub_ex,
     version: "0.0.2",
     elixir: "~> 1.2.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :httpoison],
      mod: {PubnubEx, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8.1" },
      {:exjsx, "~> 3.2.0" }
    ]
  end

  defp description do
    """
    A pubsub tool for pubnub.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Ryuichi Maeno"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/ryuone/pubnub_ex"}
    ]
  end
end
