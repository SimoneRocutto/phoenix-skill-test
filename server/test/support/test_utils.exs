defmodule Server.TestUtils do
  use ServerWeb.ConnCase

  @admin_attrs %{
    username: "admin",
    password: "admin"
  }

  def protected_route_setup(conn) do
    %{"data" => %{"token" => token}} =
      conn
      |> put_req_header("accept", "application/json")
      |> post(~p"/api/register", user: @admin_attrs)
      |> json_response(201)

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("authorization", "Bearer " <> token)}
  end
end
