defmodule Server.Users.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Phoenix.json_library().encode_to_iodata!(%{errors: %{detail: body}}))
  end
end
