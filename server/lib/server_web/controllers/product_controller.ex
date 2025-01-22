defmodule ServerWeb.ProductController do
  use ServerWeb, :controller

  alias Server.Products
  alias Server.Products.Product
  alias Server.DataUtils

  action_fallback ServerWeb.FallbackController

  def index(conn, params) do
    case DataUtils.format_index_query_params(Product, params) do
      {:error, error_type, error_message} ->
        {:error, error_type, error_message}

      {:ok, formatted_params} ->
        result = Products.list_products(formatted_params)
        render(conn, :index, result)
    end
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Products.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/products/#{product}")
      |> render(:show, product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, :show, product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, :show, product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)

    with {:ok, %Product{}} <- Products.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
