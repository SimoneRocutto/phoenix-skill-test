defmodule ServerWeb.ProductControllerTest do
  use ServerWeb.ConnCase

  import Server.ProductsFixtures

  alias ServerWeb.ProductController
  alias Server.Products.Category
  alias Server.Products.Product

  @create_attrs %{
    name: "some product name",
    price: 120.5
  }
  @create_attrs_list [
    %{
      name: "Jojo Phantom Blood vol. 1",
      price: 4.99
    },
    %{
      name: "Stardust Crusaders wallpaper",
      price: 9.99
    },
    %{
      name: "Jotaro figure",
      price: 45.00
    }
  ]
  @update_attrs %{
    name: "some updated name",
    price: 456.70
  }
  @invalid_attrs %{name: nil, price: nil}

  setup %{conn: conn} do
    Server.TestUtils.protected_route_setup(conn)
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, ~p"/api/products")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "index pagination, sort and filters" do
    setup [:create_multiple_products]

    test "pagination works", %{conn: conn} do
      conn = get(conn, ~p"/api/products?page[limit]=2&page[offset]=1")

      [
        %{
          "name" => "Stardust Crusaders wallpaper",
          "price" => 9.99
        },
        %{
          "name" => "Jotaro figure",
          "price" => 45.00
        }
      ] =
        json_response(conn, 200)["data"]
    end

    test "sorts products", %{conn: conn} do
      conn = get(conn, ~p"/api/products?sort=name")

      [
        %{
          "name" => "Jojo Phantom Blood vol. 1",
          "price" => 4.99
        },
        %{
          "name" => "Jotaro figure",
          "price" => 45.00
        },
        %{
          "name" => "Stardust Crusaders wallpaper",
          "price" => 9.99
        }
      ] =
        json_response(conn, 200)["data"]
    end

    test "filters products", %{conn: conn} do
      conn = get(conn, ~p"/api/products?filter[name]=Jo")

      [
        %{
          "name" => "Jojo Phantom Blood vol. 1",
          "price" => 4.99
        },
        %{
          "name" => "Jotaro figure",
          "price" => 45.00
        }
      ] =
        json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/products?filter[fjoijea]=a&filter[name]=b")

      json_response(conn, 422)
    end
  end

  describe "create product" do
    setup [:create_category]

    test "renders product when data is valid", %{
      conn: conn,
      category: %Category{id: category_id}
    } do
      conn =
        post(conn, ~p"/api/products",
          product: Map.merge(@create_attrs, %{category_id: category_id})
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some product name",
               "price" => 120.5,
               "category_id" => ^category_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{
      conn: conn,
      product: %Product{id: id, category_id: category_id} = product
    } do
      conn = put(conn, ~p"/api/products/#{product}", product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "price" => 456.7,
               "category_id" => ^category_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, ~p"/api/products/#{product}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/products/#{product}")
      json_response(conn, 404)
    end

    test "renders errors when invalid id is passed", %{conn: conn, product: _product} do
      conn = delete(conn, ~p"/api/products/-1")
      json_response(conn, 404)
    end
  end

  defp create_product(_) do
    product = product_fixture(%{}, true)
    %{product: product}
  end

  defp create_category(_) do
    category = category_fixture()
    %{category: category}
  end

  defp create_multiple_products(_) do
    @create_attrs_list
    |> Enum.map(&product_fixture(&1, true))
    |> then(&%{products: &1})
  end

  doctest ProductController
end
