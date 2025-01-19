defmodule Server.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :location, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone_number, :string
    field :hobby, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:first_name, :last_name, :email, :phone_number, :location, :hobby])
    |> validate_required([:first_name, :last_name, :email, :phone_number, :location, :hobby])
  end
end
