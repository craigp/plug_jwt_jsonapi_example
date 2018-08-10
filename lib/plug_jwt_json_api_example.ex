defmodule PlugJwtJsonapiExample do

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      {Plug.Adapters.Cowboy2, [
        scheme: :http,
        plug: PlugJwtJsonapiExample.Router,
        options: [port: 4002]]}
    ]
    opts = [strategy: :one_for_one, name: PlugJwtJsonapiExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def version(app \\ :plug_jwt_json_api_example) do
    Application.loaded_applications
    |> Enum.filter(&(elem(&1, 0) == app))
    |> List.first
    |> elem(2)
    |> to_string
  end

end
