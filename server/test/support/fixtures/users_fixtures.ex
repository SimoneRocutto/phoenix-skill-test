defmodule Server.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        password: "some password",
        username: "some username"
      })
      |> Server.Users.create_user()

    user
  end
end
