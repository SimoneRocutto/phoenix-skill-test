defmodule Server.TestUtils do
  use ServerWeb.ConnCase

  @admin_attrs %{
    username: "admin",
    password: "admin"
  }

  def protected_route_setup(conn) do
    %{"token" => token} =
      json_response(ServerWeb.SessionController.create(conn, %{"user" => @admin_attrs}), 201)

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "Bearer " <> token)}
  end
end
