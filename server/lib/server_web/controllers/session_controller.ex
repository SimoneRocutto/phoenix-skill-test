defmodule ServerWeb.SessionController do
  use ServerWeb, :controller

  alias Server.{Users, Users.User, Guardian}

  action_fallback ServerWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:show, user: user, token: token)
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Users.authenticate_user(username, password)
    |> login_reply(conn)
  end

  # If router passes through the pipeline, then the token is valid
  def verify_token(conn, %{}) do
    json(conn, %{message: "valid_token"})
  end

  def refresh_token(conn, %{}) do
    token = Guardian.Plug.current_token(conn)
    {:ok, _old_stuff, {new_token, _new_claims}} = Server.Guardian.refresh(token)
    json(conn, %{new_token: new_token})
  end

  # This should be tested in conjunction with a client application.
  # The client should store an auth_token in the cookies and we should
  # unset it on logout.
  def logout(conn, _) do
    conn = conn |> delete_resp_cookie("auth_token")

    json(conn, %{message: "logged out"})
  end

  defp login_reply({:ok, user}, conn) do
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")

    conn
    # Add something like this for client application (max age etc should be set).
    # |> put_resp_cookie("auth_token", token)
    |> render(:show, user: user, token: token)
  end

  defp login_reply({:error, reason}, conn) do
    json(conn, %{error: reason})
  end
end
