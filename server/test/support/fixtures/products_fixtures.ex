defmodule Server.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Products` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Server.Products.create_category()

    category
  end

  def product_fixture(attrs \\ %{}, auto_generate_category \\ false) do
    category_id =
      if auto_generate_category do
        %{id: category_id} =
          category_fixture()

        category_id
      end

    {:ok, product} =
      attrs
      |> Enum.into(%{name: "some product name", price: 123.52, category_id: category_id})
      |> Server.Products.create_product()

    product
  end

  @doc """
  Generate a category, then one or more products of that category, then one or more
  sold products for each product.

  ## Examples
    data = %{
      category: %{
        name: "manga"
      },
      products: [
        %{
          product: %{
            name: "Jojo Phantom Blood vol. 1",
            price: 4.99
          },
          sold_products: [
            %{
              selling_time: ~U[2025-01-23 16:50:00Z]
            },
            %{
              selling_time: ~U[2025-01-24 16:50:00Z]
            }
          ]
        },
        %{
          product: %{
            name: "Jojo Phantom Blood vol. 2",
            price: 4.99
          },
          sold_products: [
            %{
              selling_time: ~U[2025-01-23 15:51:00Z]
            }
          ]
        }
      ]
    }

    categories_to_sold_products_fixture(data)
  """
  def categories_to_sold_products_fixture(%{category: category_attrs, products: products}) do
    %{id: client_id} =
      Server.ClientsFixtures.client_fixture(email: "mymail#{System.unique_integer()}@email.com")

    created_category =
      category_fixture(category_attrs)

    created_products =
      products
      |> Enum.map(fn product ->
        %{product: product_attrs, sold_products: sold_products} = product

        created_product =
          product_fixture(Enum.into(product_attrs, %{category_id: created_category.id}))

        created_sold_products =
          sold_products
          |> Enum.map(fn sold_product_attrs ->
            sold_product =
              sold_product_fixture(
                Enum.into(sold_product_attrs, %{
                  product_id: created_product.id,
                  client_id: client_id
                })
              )

            sold_product
          end)

        %{product: product, sold_products: created_sold_products}
      end)

    %{category: created_category, products: created_products}
  end

  @doc """
  Generate a sold_product.
  """
  def sold_product_fixture(attrs \\ %{}, auto_generate_product \\ false) do
    [product_id, client_id] =
      if auto_generate_product do
        %{id: product_id} =
          product_fixture(%{}, true)

        %{id: client_id} =
          Server.ClientsFixtures.client_fixture()

        [product_id, client_id]
      else
        [nil, nil]
      end

    {:ok, sold_product} =
      attrs
      |> Enum.into(%{
        selling_time: ~U[2025-01-23 15:51:00Z],
        product_id: product_id,
        client_id: client_id
      })
      |> Server.Products.create_sold_product()

    sold_product
  end
end
