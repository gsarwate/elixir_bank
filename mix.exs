defmodule ElixirOTPBank.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_otp_bank,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bank.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:cowboy, "~> 2.6.3"},
      {:plug, "~> 1.8.2"},
      {:plug_cowboy, "~> 2.1.0"},
    ]
  end
end
