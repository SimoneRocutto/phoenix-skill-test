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
end
