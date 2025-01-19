defmodule Server.ClientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Clients` context.
  """

  @doc """
  Generate a client.
  """
  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(%{
        email: "some email",
        first_name: "some first_name",
        hobby: "some hobby",
        last_name: "some last_name",
        location: "some location",
        phone_number: "some phone_number"
      })
      |> Server.Clients.create_client()

    client
  end
end
