use Mix.Config

secret_key = nil

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "PlugJwtJsonapiExample",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: fn ->
    {:ok, secret_key} = Application.fetch_env(:plug_jwt_json_api_example, :secret_key)
    secret_key
  end,
  serializer: PlugJwtJsonapiExample.GuardianSerializer

import_config "#{Mix.env}.exs"
