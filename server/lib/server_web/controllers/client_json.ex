defmodule ServerWeb.ClientJSON do
  alias Server.Clients.Client

  @doc """
  Renders a list of clients.
  """
  def index(%{clients: clients}) do
    %{data: for(client <- clients, do: data(client))}
  end

  @doc """
  Renders a single client.
  """
  def show(%{client: client}) do
    %{data: data(client)}
  end

  defp data(%Client{} = client) do
    %{
      id: client.id,
      location: client.location,
      first_name: client.first_name,
      last_name: client.last_name,
      email: client.email,
      phone_number: client.phone_number,
      hobby: client.hobby
    }
  end
end
