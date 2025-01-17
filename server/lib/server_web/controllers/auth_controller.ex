defmodule ServerWeb.AuthController do
  use ServerWeb, :controller
  alias Server.Guardian

  def protected(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    json(conn, %{current_user: user.id})
  end
end
