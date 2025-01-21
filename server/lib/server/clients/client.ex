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
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> validate_format(
      :phone_number,
      ~r/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/
    )
    |> unique_constraint([:email])
  end
end
