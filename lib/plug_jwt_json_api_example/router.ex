defmodule PlugJwtJsonapiExample.Router do

  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger, otp_app: :plug_jwt_json_api_example
  end

  # plug Plug.Logger#, log: :debug
  plug Logster.Plugs.Logger#, log: :debug
  plug PlugJwtJsonapiExample.ContentTypeNegotiation
  plug :match
  plug PlugJwtJsonapiExample.Auth
  plug :dispatch

  get "/" do
    data = %{
      version: PlugJwtJsonapiExample.version,
      author: "craigp",
      url: "https://localhost:4002"
    }
    {:ok, response} =
      PlugJwtJsonapiExample.InfoSerializer
      |> JaSerializer.format(data, conn)
      |> Jason.encode
    conn |> send_resp(200, response)
  end

  get "/login" do
    {:ok, %{user_name: "craigp"}} # TODO fetch and auth the user from somewhere useful
    |> case do
      {:ok, user} ->
        {:ok, jwt, %{
          "exp" => exp
        } = _claims} = PlugJwtJsonapiExample.Guardian.encode_and_sign(user)
        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp))
        |> send_resp(200, "")
      _ ->
        conn
        |> send_resp(401, "")
    end
  end

  get "/test" do
    send_resp(conn, 200, "OK")
  end

end

