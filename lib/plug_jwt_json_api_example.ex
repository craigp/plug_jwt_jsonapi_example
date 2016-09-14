defmodule PlugJwtJsonapiExample do
  use Application
  require Logger

  def start(_type, _args) do
    Application.put_env :plug_jwt_json_api_example, :secret_key,
      JOSE.JWS.generate_key(%{"alg" => "HS512"})
    import Supervisor.Spec, warn: false
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, PlugJwtJsonapiExample.Router, [], [port: 4002])
    ]
    opts = [strategy: :one_for_one, name: PlugJwtJsonapiExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_args) do
    # noop
  end

  def version(app \\ :plug_jwt_json_api_example) do
    Application.loaded_applications
    |> Enum.filter(&(elem(&1, 0) == app))
    |> List.first
    |> elem(2)
    |> to_string
  end

end
