defmodule PlugJwtJsonapiExample.Auth do

  alias PlugJwtJsonapiExample.Guardian

  use Plug.Builder

  plug :validate_token

  def validate_token(%Plug.Conn{
    request_path: "/login"
  } = conn, _opts), do: conn

  def validate_token(conn, _opts) do
    conn
    |> get_req_header("authorization")
    |> do_validate_token(conn)
  end

  defp do_validate_token([], conn) do
    conn
    |> send_resp(401, "")
    |> halt
  end

  defp do_validate_token(["Bearer " <> token|t], conn) do
    case Guardian.decode_and_verify(token) do
      {:error, _} ->
        do_validate_token(t, conn)
      {:ok, %{"exp" => _exp}} ->
        conn
    end
  end

end
