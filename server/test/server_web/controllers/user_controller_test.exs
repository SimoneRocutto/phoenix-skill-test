defmodule ServerWeb.UserControllerTest do
  use ServerWeb.ConnCase

  import Server.UsersFixtures

  alias Server.Users.User

  @create_attrs %{
    username: "some username",
    password: "some password"
  }
  @update_attrs %{
    username: "some updated username",
    password: "some updated password"
  }
  @invalid_attrs %{username: nil, password: nil}

  setup %{conn: conn} do
    Server.TestUtils.protected_route_setup(conn)
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      # Length is 1 because admin user is present (see setup higher up)
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      %{username: username} = @create_attrs

      assert %{
               "id" => ^id,
               "password" => hashed_password,
               "username" => ^username
             } = json_response(conn, 200)["data"]

      assert(Argon2.verify_pass(@create_attrs.password, hashed_password))
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      %{username: username} = @update_attrs

      assert %{
               "id" => ^id,
               "password" => hashed_password,
               "username" => ^username
             } = json_response(conn, 200)["data"]

      assert(Argon2.verify_pass(@update_attrs.password, hashed_password))
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
