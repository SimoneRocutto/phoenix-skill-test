defmodule ServerWeb.ClientControllerTest do
  use ServerWeb.ConnCase
  use ExUnit.Case, async: true

  import Server.ClientsFixtures

  alias Server.Clients.Client
  alias ServerWeb.ClientController

  @create_attrs %{
    first_name: "some first name",
    last_name: "some last name",
    email: "some@email.com",
    location: "some location",
    phone_number: "+391234567890",
    hobby: "some hobby"
  }
  @create_attrs_list [
    %{
      first_name: "a",
      last_name: "a",
      email: "a@mail.com"
    },
    %{
      first_name: "a",
      last_name: "b",
      email: "b@mail.com"
    },
    %{
      first_name: "b",
      last_name: "b",
      email: "c@mail.com"
    }
  ]
  @update_attrs %{
    first_name: "new first name",
    last_name: "new last name",
    email: "new@email.com",
    location: "new location",
    phone_number: "+441234567890",
    hobby: "new hobby"
  }
  @invalid_attrs_list [
    %{
      first_name: "some first name",
      last_name: "some last name",
      email: "@notanemail.it"
    },
    %{
      first_name: "some first name",
      last_name: "some last name",
      email: "some@email.it",
      phone_number: "not a phone number"
    }
  ]

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clients", %{conn: conn} do
      conn = get(conn, ~p"/api/clients")
      res = json_response(conn, 200)
      assert res["data"] == []
      assert res["pagination"]["total_count"] == 0
    end
  end

  describe "index pagination, sort and filters" do
    setup [:create_multiple_clients]

    test "pagination works", %{conn: conn} do
      conn = get(conn, ~p"/api/clients?page[limit]=2&page[offset]=1")

      [
        %{
          "first_name" => "a",
          "last_name" => "b",
          "email" => "b@mail.com"
        },
        %{
          "first_name" => "b",
          "last_name" => "b",
          "email" => "c@mail.com"
        }
      ] =
        json_response(conn, 200)["data"]
    end

    test "sorts clients", %{conn: conn} do
      conn = get(conn, ~p"/api/clients?sort=-first_name,-last_name")

      [
        %{
          "first_name" => "b",
          "last_name" => "b",
          "email" => "c@mail.com"
        },
        %{
          "first_name" => "a",
          "last_name" => "b",
          "email" => "b@mail.com"
        },
        %{
          "first_name" => "a",
          "last_name" => "a",
          "email" => "a@mail.com"
        }
      ] =
        json_response(conn, 200)["data"]
    end

    test "filters clients", %{conn: conn} do
      conn = get(conn, ~p"/api/clients?filter[first_name]=a")

      [
        %{
          "first_name" => "a",
          "last_name" => "a",
          "email" => "a@mail.com"
        },
        %{
          "first_name" => "a",
          "last_name" => "b",
          "email" => "b@mail.com"
        }
      ] =
        json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/clients?filter[first_name]=a&filter[last_name]=b")

      [
        %{
          "first_name" => "a",
          "last_name" => "b",
          "email" => "b@mail.com"
        }
      ] =
        json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/clients?filter[fjoijea]=a&filter[last_name]=b")

      json_response(conn, 422)
    end
  end

  describe "create client" do
    test "renders client when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/clients", client: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clients/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => "some first name",
               "last_name" => "some last name",
               "email" => "some@email.com",
               "location" => "some location",
               "phone_number" => "+391234567890",
               "hobby" => "some hobby"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      Enum.each(
        @invalid_attrs_list,
        fn invalid_attrs ->
          conn = post(conn, ~p"/api/clients", client: invalid_attrs)
          assert json_response(conn, 422)["errors"] != %{}
        end
      )
    end
  end

  describe "update client" do
    setup [:create_client]

    test "renders client when data is valid", %{conn: conn, client: %Client{id: id} = client} do
      conn = put(conn, ~p"/api/clients/#{client}", client: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/clients/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => "new first name",
               "last_name" => "new last name",
               "email" => "new@email.com",
               "location" => "new location",
               "phone_number" => "+441234567890",
               "hobby" => "new hobby"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, client: client} do
      Enum.each(
        @invalid_attrs_list,
        fn invalid_attrs ->
          conn = put(conn, ~p"/api/clients/#{client}", client: invalid_attrs)
          assert json_response(conn, 422)["errors"] != %{}
        end
      )
    end
  end

  describe "delete client" do
    setup [:create_client]

    test "deletes chosen client", %{conn: conn, client: client} do
      conn = delete(conn, ~p"/api/clients/#{client}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clients/#{client}")
      end
    end
  end

  defp create_client(_) do
    client = client_fixture()
    %{client: client}
  end

  defp create_multiple_clients(_) do
    @create_attrs_list
    |> Enum.map(&client_fixture(&1, true))
    |> then(&%{clients: &1})
  end

  doctest ClientController
end
