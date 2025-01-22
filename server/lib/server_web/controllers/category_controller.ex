defmodule ServerWeb.CategoryController do
  use ServerWeb, :controller

  alias Server.Products
  alias Server.Products.Category
  alias Server.DataUtils

  action_fallback ServerWeb.FallbackController

  def index(conn, params) do
    case DataUtils.format_index_query_params(Category, params) do
      {:error, error_type, error_message} ->
        {:error, error_type, error_message}

      {:ok, formatted_params} ->
        result = Products.list_categories(formatted_params)
        render(conn, :index, result)
    end
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Products.create_category(category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/categories/#{category}")
      |> render(:show, category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Products.get_category!(id)
    render(conn, :show, category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Products.get_category!(id)

    with {:ok, %Category{} = category} <- Products.update_category(category, category_params) do
      render(conn, :show, category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Products.get_category!(id)

    with {:ok, %Category{}} <- Products.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end
end
