defmodule Server.ClientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Clients` context.
  """

  @doc """
  Generate a client.
  """
  def client_fixture(attrs \\ %{}, full_override \\ false) do
    default =
      if full_override do
        %{}
      else
        %{
          email: "some@email.com",
          first_name: "some first_name",
          hobby: "some hobby",
          last_name: "some last_name",
          location: "some location",
          phone_number: "+391029394832"
        }
      end

    {:ok, client} =
      attrs
      |> Enum.into(default)
      |> Server.Clients.create_client()

    client
  end
end
