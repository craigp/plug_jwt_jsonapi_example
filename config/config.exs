use Mix.Config

secret_key = nil

config :plug_jwt_json_api_example, PlugJwtJsonapiExample.Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "PlugJwtJsonapiExample",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: :crypto.strong_rand_bytes(32) |> Base.encode64() |> binary_part(0, 32)

import_config "#{Mix.env}.exs"
