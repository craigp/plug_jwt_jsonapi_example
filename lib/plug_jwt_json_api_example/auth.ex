defmodule PlugJwtJsonapiExample.Auth do
  use Plug.Builder

  plug :validate_token

  def validate_token(%Plug.Conn{} = conn, _opts) do
    case conn.request_path do
      "/login" ->
        conn
      _ ->
        case Plug.Conn.get_req_header(conn, "authorization") do
          ["Bearer " <> token] ->
            Guardian.decode_and_verify(token, %{})
            |> case do
              {:error, _} ->
                conn
                |> send_resp(401, "")
                |> halt
              {:ok, %{"exp" => _exp}} ->
                conn
            end
          _ ->
            conn
            |> send_resp(401, "")
            |> halt
        end
    end
  end

end
