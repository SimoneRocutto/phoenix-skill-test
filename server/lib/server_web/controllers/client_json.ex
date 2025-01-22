defmodule ServerWeb.ClientJSON do
  alias Server.Clients.Client
  alias Server.DataUtils

  @doc """
  Renders a list of clients.
  """
  @spec index(%{data: [%Client{}], pagination: map()}) :: %{data: [map()], pagination: map()}
  def index(raw_data) do
    DataUtils.format_index_response(raw_data, &data/1)
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
