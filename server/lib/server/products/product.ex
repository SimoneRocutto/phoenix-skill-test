defmodule Server.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :float
    field :category_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :category_id])
    |> validate_required([:name, :price, :category_id])
    |> foreign_key_constraint(:category_id)
  end
end
