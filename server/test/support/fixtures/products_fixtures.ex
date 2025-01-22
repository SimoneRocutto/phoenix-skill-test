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

  def product_fixture(attrs \\ %{category: %{}, product: %{}}) do
    %{category: category_attrs, product: product_attrs} = attrs
    category = category_fixture(Enum.into(category_attrs, %{name: "some category name"}))

    {:ok, product} =
      product_attrs
      |> Enum.into(%{name: "some product name", price: 123.52, category_id: category.id})
      |> Server.Products.create_product()

    %{product: product, category: category}
  end

  # @doc """
  # Generate a product.
  # """
  # def product_fixture(attrs \\ %{}) do
  #   {:ok, product} =
  #     attrs
  #     |> Enum.into(%{
  #       name: "some name",
  #       price: 120.55
  #     })
  #     |> Server.Products.create_product()

  #   product
  # end
end
