defmodule PlugJwtJsonapiExample.ContentTypeNegotiation do
  use Plug.Builder

  @jsonapi "application/vnd.api+json"

  plug :validate_content_type
  plug :validate_accept
  plug :set_content_type

  def validate_content_type(%Plug.Conn{} = conn, _opts) do
    get_req_header(conn, "content-type")
    |> validate_content_type(conn)
  end

  def validate_content_type([], conn) do
    conn
    |> send_resp(415, "")
    |> halt
  end

  def validate_content_type([content_type|other] = content_types, conn) when length(content_types) > 0 do
    cond do
      content_type == @jsonapi ->
        conn
      true ->
        validate_content_type(other, conn)
    end
  end

  def validate_content_type(_, conn) do
    conn
    |> send_resp(415, "")
    |> halt
  end

  def validate_accept(%Plug.Conn{} = conn, _opts) do
    conn
    |> get_req_header("accept")
    |> Enum.flat_map(&(String.split(&1, ",")))
    |> Enum.map(&String.strip/1)
    |> validate_accept(conn)
  end

  def validate_accept(accepts, conn) do
    case accepts do
      [] ->
        conn
        |> send_resp(406, "")
        |> halt
      [@jsonapi|_] ->
        conn
      ["application/*"|_] ->
        conn
      ["*/*"] ->
        conn
      [_|other] ->
        validate_accept(other, conn)
    end
  end

  def set_content_type(conn, _opts) do
    register_before_send(conn, fn(later_conn) ->
      update_resp_header(later_conn, "content-type", @jsonapi, &(&1))
    end)
  end

end
