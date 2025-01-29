defmodule ServerWeb.SoldProductJSON do
  alias Server.Products.SoldProduct

  @doc """
  Renders a list of sold_products.
  """
  def index(%{sold_products: sold_products}) do
    %{data: for(sold_product <- sold_products, do: data(sold_product))}
  end

  @doc """
  Renders a single sold_product.
  """
  def show(%{sold_product: sold_product}) do
    %{data: data(sold_product)}
  end

  defp data(%SoldProduct{} = sold_product) do
    %{
      id: sold_product.id,
      selling_time: sold_product.selling_time,
      client_id: sold_product.client_id,
      product_id: sold_product.product_id
    }
  end
end
