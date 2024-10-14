defmodule ElixirOTPBank.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_otp_bank,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [release: :prod]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Bank.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:cowboy, "~> 2.7"},
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.7.2"},
      {:distillery, "~> 2.0"}
    ]
  end
end
