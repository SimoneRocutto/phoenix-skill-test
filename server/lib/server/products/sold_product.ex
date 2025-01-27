defmodule Server.Products.SoldProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sold_products" do
    field :selling_time, :utc_datetime
    field :product_id, :id
    field :client_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sold_product, attrs) do
    sold_product
    |> cast(attrs, [:selling_time, :product_id, :client_id])
    |> validate_required([:selling_time, :product_id, :client_id])
  end
end
