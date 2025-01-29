defmodule ServerWeb.NotFoundController do
  use ServerWeb, :controller

  action_fallback ServerWeb.FallbackController

  def not_found(conn, _) do
    conn
    |> put_status(:not_found)
    |> put_view(json: ServerWeb.ErrorJSON)
    |> render(:route_404)
  end
end
