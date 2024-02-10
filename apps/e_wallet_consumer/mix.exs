defmodule EWalletConsumer.MixProject do
  use Mix.Project

  def project do
    [
      app: :e_wallet_consumer,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EWalletConsumer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:e_wallet_service, in_umbrella: true},
      {:brod, "~> 3.17.0"},
      {:broadway, "~> 1.0"},
      {:broadway_kafka, "~> 0.4.1"}
    ]
  end
end
