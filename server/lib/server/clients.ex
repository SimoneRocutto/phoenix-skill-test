defmodule Server.Clients do
  @moduledoc """
  The Clients context.
  """

  import Ecto.Query, warn: false
  alias Server.{Repo, DataUtils}

  alias Server.Clients.Client

  @doc """
  Returns the list of clients with pagination data.

  ## Examples

      iex> list_clients(%{limit: 10, offset: 0, sort: [asc: :first_name], filter: %{last_name: "b"}})
      %{data: [%Client{}, ...], pagination: %{total_count: 100, limit: 10, offset: 0}}

  """
  @spec list_clients(%{
          optional(:limit) => integer(),
          optional(:offset) => integer(),
          optional(:sort) => any(),
          optional(:filter) => any()
        }) ::
          %{
            data: [...],
            pagination: %{
              total_count: integer(),
              limit: integer(),
              offset: integer()
            }
          }
  def list_clients(formatted_params \\ %{}) do
    DataUtils.list_query(Client, formatted_params)
  end

  @doc """
  Gets a single client.

  Raises `Ecto.NoResultsError` if the Client does not exist.

  ## Examples

      iex> get_client!(123)
      %Client{}

      iex> get_client!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client!(id), do: Repo.get!(Client, id)

  @doc """
  Creates a client.

  ## Examples

      iex> create_client(%{field: value})
      {:ok, %Client{}}

      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client(attrs \\ %{}) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update_client(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update_client(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client(%Client{} = client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client.

  ## Examples

      iex> delete_client(client)
      {:ok, %Client{}}

      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.

  ## Examples

      iex> change_client(client)
      %Ecto.Changeset{data: %Client{}}

  """
  def change_client(%Client{} = client, attrs \\ %{}) do
    Client.changeset(client, attrs)
  end
end
