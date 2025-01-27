defmodule Server.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Server.{Repo, DataUtils}

  alias Server.Products.Category

  @doc """
  Returns the list of categories with pagination data.

  ## Examples

      iex> list_categories(%{limit: 10, offset: 0, sort: [asc: :name], filter: %{name: "a"}})
      %{data: [%Category{}, ...], pagination: %{total_count: 100, limit: 10, offset: 0}}

  """
  @spec list_categories(%{
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
  def list_categories(formatted_params \\ %{}) do
    DataUtils.list_query(Category, formatted_params)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias Server.Products.Product

  @doc """
  Returns the list of products with pagination data.

  ## Examples

      iex> list_products(%{limit: 10, offset: 0, sort: [asc: :name], filter: %{name: "a"}})
      %{data: [%Product{}, ...], pagination: %{total_count: 100, limit: 10, offset: 0}}

  """
  @spec list_products(%{
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
  def list_products(formatted_params \\ %{}) do
    DataUtils.list_query(Product, formatted_params)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Server.Products.SoldProduct

  @doc """
  Returns the list of sold_products.

  ## Examples

      iex> list_sold_products()
      [%SoldProduct{}, ...]

  """
  def list_sold_products do
    Repo.all(SoldProduct)
  end

  @doc """
  Gets a single sold_product.

  Raises `Ecto.NoResultsError` if the Sold product does not exist.

  ## Examples

      iex> get_sold_product!(123)
      %SoldProduct{}

      iex> get_sold_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sold_product!(id), do: Repo.get!(SoldProduct, id)

  @doc """
  Creates a sold_product.

  ## Examples

      iex> create_sold_product(%{field: value})
      {:ok, %SoldProduct{}}

      iex> create_sold_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sold_product(attrs \\ %{}) do
    %SoldProduct{}
    |> SoldProduct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sold_product.

  ## Examples

      iex> update_sold_product(sold_product, %{field: new_value})
      {:ok, %SoldProduct{}}

      iex> update_sold_product(sold_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sold_product(%SoldProduct{} = sold_product, attrs) do
    sold_product
    |> SoldProduct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sold_product.

  ## Examples

      iex> delete_sold_product(sold_product)
      {:ok, %SoldProduct{}}

      iex> delete_sold_product(sold_product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sold_product(%SoldProduct{} = sold_product) do
    Repo.delete(sold_product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sold_product changes.

  ## Examples

      iex> change_sold_product(sold_product)
      %Ecto.Changeset{data: %SoldProduct{}}

  """
  def change_sold_product(%SoldProduct{} = sold_product, attrs \\ %{}) do
    SoldProduct.changeset(sold_product, attrs)
  end

  @doc """
  Returns sold products count grouped by category.

  ## Examples

      iex> sold_products_by_category()
      [
        %{"category_name" => "figures", "sold_products_count" => 4},
        %{"category_name" => "manga", "sold_products_count" => 3}
      ]

  """
  def sold_products_by_category do
    query =
      from sp in SoldProduct,
        join: p in Product,
        on: sp.product_id == p.id,
        join: c in Category,
        on: p.category_id == c.id,
        order_by: c.name,
        group_by: c.id,
        select: %{category_id: c.id, category_name: c.name, sold_products_count: count(c.id)}

    Repo.all(query)
  end

  @doc """
  Returns sold products count grouped by month.

  ## Examples

      iex> sold_products_by_month()
      [
        %{"count" => 2, "date" => "2024-11-01T00:00:00.000000"},
        %{"count" => 1, "date" => "2024-12-01T00:00:00.000000"},
        %{"count" => 4, "date" => "2025-01-01T00:00:00.000000"}
      ]
  """
  def sold_products_by_month do
    query =
      from sp in SoldProduct,
        order_by: [fragment("date_trunc('month', ?)", sp.selling_time)],
        group_by: [fragment("date_trunc('month', ?)", sp.selling_time)],
        select: %{
          date: fragment("date_trunc('month', ?)", sp.selling_time),
          count: count(sp.id)
        }

    Repo.all(query)
  end

  @doc """
  Returns money income by month.

  ## Examples

      iex> monthly_income()
      [
        %{"date" => "2024-11-01T00:00:00.000000", "income" => 69.98},
        %{"date" => "2024-12-01T00:00:00.000000", "income" => 29.99},
        %{"date" => "2025-01-01T00:00:00.000000", "income" => 54.96}
      ]
  """
  def monthly_income do
    query =
      from sp in SoldProduct,
        join: p in Product,
        on: sp.product_id == p.id,
        order_by: [fragment("date_trunc('month', ?)", sp.selling_time)],
        group_by: [fragment("date_trunc('month', ?)", sp.selling_time)],
        select: %{
          date: fragment("date_trunc('month', ?)", sp.selling_time),
          income: sum(p.price)
        }

    Repo.all(query)
  end
end
