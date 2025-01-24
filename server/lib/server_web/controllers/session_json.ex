defmodule ServerWeb.SessionJSON do
  alias Server.Users.User

  @doc """
  Renders a single user after login or registration.
  """
  def show(%{user: user, token: token}) do
    %{data: %{user: data(user), token: token}}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username
    }
  end
end
