defmodule ServerWeb.SoldProductController do
  use ServerWeb, :controller

  alias Server.Products
  alias Server.Products.SoldProduct

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    sold_products = Products.list_sold_products()
    render(conn, :index, sold_products: sold_products)
  end

  def create(conn, %{"sold_product" => sold_product_params}) do
    with {:ok, %SoldProduct{} = sold_product} <- Products.create_sold_product(sold_product_params) do
      conn
      |> put_status(:created)
      |> render(:show, sold_product: sold_product)
    end
  end

  def show(conn, %{"id" => id}) do
    case Products.get_sold_product(id) do
      nil -> {:error, :not_found}
      sold_product -> render(conn, :show, sold_product: sold_product)
    end
  end

  def update(conn, %{"id" => id, "sold_product" => sold_product_params}) do
    case Products.get_sold_product(id) do
      nil ->
        {:error, :not_found}

      sold_product ->
        with {:ok, %SoldProduct{} = sold_product} <-
               Products.update_sold_product(sold_product, sold_product_params) do
          render(conn, :show, sold_product: sold_product)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Products.get_sold_product(id) do
      nil ->
        {:error, :not_found}

      sold_product ->
        with {:ok, %SoldProduct{}} <- Products.delete_sold_product(sold_product) do
          send_resp(conn, :no_content, "")
        end
    end
  end

  def sold_products_by_category(conn, _params) do
    res = Products.sold_products_by_category()
    json(conn, res)
  end

  def sold_products_by_month(conn, _params) do
    res = Products.sold_products_by_month()
    json(conn, res)
  end

  def monthly_income(conn, _params) do
    res = Products.monthly_income()
    json(conn, res)
  end
end
