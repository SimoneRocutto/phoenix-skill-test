defmodule ServerWeb.UserController do
  use ServerWeb, :controller

  alias Server.{Users, Users.User, Guardian}

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil -> {:error, :not_found}
      user -> render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Users.get_user(id) do
      nil ->
        {:error, :not_found}

      user ->
        with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
          render(conn, :show, user: user)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        {:error, :not_found}

      user ->
        with {:ok, %User{}} <- Users.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
    end
  end

  def get_reset_token(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user, %{}, token_type: "reset")

    json(conn, %{token: token})
  end

  def reset_password(conn, %{"password" => password}) do
    user = Guardian.Plug.current_resource(conn)
    Users.update_user(user, %{password: password})
    json(conn, %{message: "password change successful!"})
  end

  def reset_password(_conn, _) do
    {:error, :bad_request}
  end
end
