use Mix.Config

config :elixir_otp_bank, http_port: 5454

import_config "#{Mix.env()}.exs"
