defmodule ServerWeb.SessionControllerTest do
  use ServerWeb.ConnCase

  @create_attrs %{
    username: "some username",
    password: "some password"
  }
  @invalid_attrs %{username: nil, password: nil}

  describe "registers and logs in user" do
    test "registers user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/register", user: @create_attrs)
      %{"user" => user, "token" => _token} = json_response(conn, 201)["data"]

      assert %{"id" => register_id, "username" => register_username} = user
      assert register_username == @create_attrs.username

      conn =
        conn
        |> post(~p"/api/login", user: @create_attrs)

      assert %{"id" => login_id, "username" => login_username} =
               json_response(conn, 200)["data"]["user"]

      assert register_id == login_id
      assert register_username == login_username
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/register", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "verify" do
    test "recognizes missing token as invalid", %{conn: conn} do
      test_token_validity(conn, nil, true)
    end

    test "recognizes valid token", %{conn: conn} do
      {:ok, conn: conn} = Server.TestUtils.protected_route_setup(conn)
      test_token_validity(conn)
    end

    test "recognizes invalid token", %{conn: conn} do
      invalid_token = "helloiamnotvalid"

      {:ok, conn: conn} = Server.TestUtils.protected_route_setup(conn)
      test_token_validity(conn, invalid_token, true)
    end
  end

  describe "refresh token" do
    setup %{conn: conn} do
      Server.TestUtils.protected_route_setup(conn)
    end

    test "works", %{conn: conn} do
      first_token =
        conn
        |> get_req_header("authorization")
        |> List.first()
        |> String.trim_leading("Bearer ")

      %{"new_token" => new_token} =
        conn
        |> post(~p"/api/refresh")
        |> json_response(200)

      assert first_token != new_token

      test_token_validity(conn, new_token)
    end
  end

  defp test_token_validity(conn, token \\ nil, test_invalid \\ false) do
    if is_bitstring(token) do
      put_req_header(conn, "authorization", "Bearer " <> token)
    else
      conn
    end
    |> post(~p"/api/verify")
    |> json_response(200)
    |> Map.get("message")
    |> then(
      &case &1 do
        "invalid_token" -> test_invalid
        "valid_token" -> !test_invalid
      end
    )
    |> assert("token validity is not as expected")
  end
end
