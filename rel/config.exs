use Mix.Releases.Config, default_environment: :prod

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :elixir_otp_bank)
end

release :elixir_otp_bank do
  set(version: curren_version(:elixir_otp_bank))
end
