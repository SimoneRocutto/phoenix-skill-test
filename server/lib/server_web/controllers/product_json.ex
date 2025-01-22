defmodule ServerWeb.ProductJSON do
  alias Server.Products.Product
  alias Server.DataUtils

  @doc """
  Renders a list of products.
  """
  @spec index(%{data: [%Product{}], pagination: map()}) :: %{data: [map()], pagination: map()}
  def index(raw_data) do
    DataUtils.format_index_response(raw_data, &data/1)
  end

  @doc """
  Renders a single product.
  """
  def show(%{product: product}) do
    %{data: data(product)}
  end

  defp data(%Product{} = product) do
    %{
      id: product.id,
      name: product.name,
      price: product.price,
      category_id: product.category_id
    }
  end
end
