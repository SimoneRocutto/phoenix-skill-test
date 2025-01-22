defmodule Server.ProductsTest do
  use Server.DataCase

  alias Server.Products

  describe "categories" do
    alias Server.Products.Category

    import Server.ProductsFixtures

    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Products.list_categories()[:data] == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Products.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Category{} = category} = Products.create_category(valid_attrs)
      assert category.name == valid_attrs.name
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Products.update_category(category, update_attrs)
      assert category.name == update_attrs.name
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_category(category, @invalid_attrs)
      assert category == Products.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Products.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Products.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Products.change_category(category)
    end
  end

  describe "products" do
    alias Server.Products.Product

    import Server.ProductsFixtures

    @invalid_attrs %{name: nil, price: nil}

    @tag :f
    test "list_products/0 returns all products" do
      product = product_fixture()[:product]
      assert Products.list_products()[:data] == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()[:product]
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      category = category_fixture()
      valid_attrs = %{name: "some name", price: 120.5, category_id: category.id}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == valid_attrs.name
      assert product.price == valid_attrs.price
      assert product.category_id == valid_attrs.category_id
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()[:product]
      new_category = category_fixture()
      update_attrs = %{name: "some updated name", price: 456.7, category_id: new_category.id}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.name == update_attrs.name
      assert product.price == update_attrs.price
      assert product.category_id == update_attrs.category_id
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()[:product]
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()[:product]
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()[:product]
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
