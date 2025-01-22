defmodule Server.ClientsTest do
  use Server.DataCase

  alias Server.Clients

  describe "clients" do
    alias Server.Clients.Client

    import Server.ClientsFixtures

    @invalid_attrs %{
      location: nil,
      first_name: nil,
      last_name: nil,
      email: nil,
      phone_number: nil,
      hobby: nil
    }

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Clients.list_clients()[:data] == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      valid_attrs = %{
        location: "some location",
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some@email.com",
        phone_number: "+442378394212",
        hobby: "some hobby"
      }

      assert {:ok, %Client{} = client} = Clients.create_client(valid_attrs)
      assert client.location == valid_attrs.location
      assert client.first_name == valid_attrs.first_name
      assert client.last_name == valid_attrs.last_name
      assert client.email == valid_attrs.email
      assert client.phone_number == valid_attrs.phone_number
      assert client.hobby == valid_attrs.hobby
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()

      update_attrs = %{
        location: "some updated location",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        email: "mynew@mail.com",
        phone_number: "+390982340983",
        hobby: "some updated hobby"
      }

      assert {:ok, %Client{} = client} = Clients.update_client(client, update_attrs)
      assert client.location == update_attrs.location
      assert client.first_name == update_attrs.first_name
      assert client.last_name == update_attrs.last_name
      assert client.email == update_attrs.email
      assert client.phone_number == update_attrs.phone_number
      assert client.hobby == update_attrs.hobby
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end
end
