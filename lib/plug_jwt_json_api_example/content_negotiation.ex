defmodule PlugJwtJsonapiExample.ContentTypeNegotiation do
  use Plug.Builder

  @jsonapi "application/vnd.api+json"

  plug :validate_content_type
  plug :validate_accept
  plug :set_content_type

  def validate_content_type(%Plug.Conn{} = conn, _opts) do
    conn
    |> get_req_header("content-type")
    |> Enum.map(fn hdr -> hd(String.split(hdr, ";")) end)
    |> validate_content_type(conn)
  end

  def validate_content_type([], conn) do
    conn
    |> send_resp(415, "")
    |> halt
  end

  def validate_content_type([h|_], conn) when h == @jsonapi, do: conn

  def validate_content_type([_|t], conn), do: validate_content_type(t, conn)

  def validate_accept(%Plug.Conn{} = conn, _opts) do
    conn
    |> get_req_header("accept")
    |> Enum.flat_map(&(String.split(&1, ",")))
    |> Enum.map(&String.trim/1)
    |> validate_accept(conn)
  end

  def validate_accept([], conn) do
    conn
    |> send_resp(406, "")
    |> halt
  end

  def validate_accept([h|_], conn) when h == @jsonapi, do: conn

  def validate_accept(["application/*"|_], conn), do: conn

  def validate_accept(["*/*"|_], conn), do: conn

  def validate_accept([_|t], conn), do: validate_accept(t, conn)

  def set_content_type(conn, _opts) do
    register_before_send(conn, fn(later_conn) ->
      update_resp_header(later_conn, "content-type", @jsonapi, &(&1))
    end)
  end

end
