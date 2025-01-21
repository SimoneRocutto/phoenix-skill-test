defmodule ServerWeb.ClientController do
  use ServerWeb, :controller

  alias Server.{Clients, Clients.Client, DataUtils}

  action_fallback ServerWeb.FallbackController

  def index(conn, params) do
    case DataUtils.format_index_query_params(Client, params) do
      {:error, error_type, error_message} ->
        {:error, error_type, error_message}

      {:ok, formatted_params} ->
        result = Clients.list_clients(formatted_params)
        render(conn, :index, result)
    end
  end

  def create(conn, %{"client" => client_params}) do
    with {:ok, %Client{} = client} <- Clients.create_client(client_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clients/#{client}")
      |> render(:show, client: client)
    end
  end

  def show(conn, %{"id" => id}) do
    client = Clients.get_client!(id)
    render(conn, :show, client: client)
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Clients.get_client!(id)

    with {:ok, %Client{} = client} <- Clients.update_client(client, client_params) do
      render(conn, :show, client: client)
    end
  end

  def delete(conn, %{"id" => id}) do
    client = Clients.get_client!(id)

    with {:ok, %Client{}} <- Clients.delete_client(client) do
      send_resp(conn, :no_content, "")
    end
  end
end
