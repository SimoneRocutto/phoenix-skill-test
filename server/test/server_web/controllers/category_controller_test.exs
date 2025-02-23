defmodule ServerWeb.CategoryControllerTest do
  use ServerWeb.ConnCase

  import Server.ProductsFixtures

  alias ServerWeb.CategoryController
  alias Server.Products.Category

  @create_attrs %{
    name: "some name"
  }
  @create_attrs_list [
    %{
      name: "manga"
    },
    %{
      name: "figure"
    },
    %{
      name: "wallpaper"
    }
  ]
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    Server.TestUtils.protected_route_setup(conn)
  end

  describe "index" do
    test "lists all categories", %{conn: conn} do
      conn = get(conn, ~p"/api/categories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "index pagination, sort and filters" do
    setup [:create_multiple_categories]

    test "pagination works", %{conn: conn} do
      conn = get(conn, ~p"/api/categories?page[limit]=2&page[offset]=1")

      [
        %{
          "name" => "figure"
        },
        %{
          "name" => "wallpaper"
        }
      ] =
        json_response(conn, 200)["data"]
    end

    test "sorts categories", %{conn: conn} do
      conn = get(conn, ~p"/api/categories?sort=name")

      [
        %{
          "name" => "figure"
        },
        %{
          "name" => "manga"
        },
        %{
          "name" => "wallpaper"
        }
      ] =
        json_response(conn, 200)["data"]
    end

    test "filters categories", %{conn: conn} do
      conn = get(conn, ~p"/api/categories?filter[name]=a")

      [
        %{
          "name" => "manga"
        },
        %{
          "name" => "wallpaper"
        }
      ] =
        json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/categories?filter[fjoijea]=a&filter[name]=b")

      json_response(conn, 422)
    end
  end

  describe "create category" do
    test "renders category when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/categories", category: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/categories/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/categories", category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update category" do
    setup [:create_category]

    test "renders category when data is valid", %{
      conn: conn,
      category: %Category{id: id} = category
    } do
      conn = put(conn, ~p"/api/categories/#{category}", category: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/categories/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put(conn, ~p"/api/categories/#{category}", category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, ~p"/api/categories/#{category}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/categories/#{category}")
      json_response(conn, 404)
    end

    test "renders errors when invalid id is passed", %{conn: conn, category: _category} do
      conn = delete(conn, ~p"/api/categories/-1")
      json_response(conn, 404)
    end
  end

  defp create_category(_) do
    category = category_fixture()
    %{category: category}
  end

  defp create_multiple_categories(_) do
    @create_attrs_list
    |> Enum.map(&category_fixture(&1))
    |> then(&%{categories: &1})
  end

  doctest CategoryController
end
