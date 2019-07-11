use Mix.Config

config :elixir_otp_bank, :database, pool_size: 3, folder: "./data/customer"
config :elixir_otp_bank, http_port: 5454
config :elixir_otp_bank, todo_item_expiry: :timer.minutes(1)

import_config "#{Mix.env()}.exs"
