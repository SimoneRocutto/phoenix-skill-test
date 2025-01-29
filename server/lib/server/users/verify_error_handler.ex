defmodule Server.Users.VerifyErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    # TODO write it the Elixir way
    {err_code, body, content_type} =
      case type do
        :invalid_token ->
          {200, Phoenix.json_library().encode_to_iodata!(%{message: type}), "application/json"}

        _ ->
          {400, to_string(type), "text/plain"}
      end

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(err_code, body)
  end
end
