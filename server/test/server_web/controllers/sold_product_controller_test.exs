defmodule ServerWeb.SoldProductControllerTest do
  use ServerWeb.ConnCase

  import Server.ProductsFixtures

  @sample_categories [
    %{
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
    },
    %{
      category: %{
        name: "figures"
      },
      products: [
        %{
          product: %{
            name: "Jotaro figure",
            price: 29.99
          },
          sold_products: [
            %{
              selling_time: ~U[2024-12-23 16:50:00Z]
            },
            %{
              selling_time: ~U[2024-11-30 16:50:00Z]
            }
          ]
        },
        %{
          product: %{
            name: "Dio Brando figure",
            price: 39.99
          },
          sold_products: [
            %{
              selling_time: ~U[2024-11-23 15:51:00Z]
            },
            %{
              selling_time: ~U[2025-01-23 15:51:00Z]
            }
          ]
        }
      ]
    }
  ]

  setup %{conn: conn} do
    Server.TestUtils.protected_route_setup(conn)
  end

  describe "index" do
    test "lists all sold_products", %{conn: conn} do
      conn = get(conn, ~p"/api/sold-products")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "sold products by category" do
    setup [:create_sold_products]

    test "works", %{conn: conn} do
      conn = get(conn, ~p"/api/sold-products/sold-products-by-category")

      [
        %{"category_name" => "figures", "sold_products_count" => 4},
        %{"category_name" => "manga", "sold_products_count" => 3}
      ] =
        json_response(conn, 200)
    end
  end

  describe("sold products by month") do
    setup [:create_sold_products]

    test "works", %{conn: conn} do
      conn = get(conn, ~p"/api/sold-products/sold-products-by-month")

      [
        %{"count" => 2, "date" => "2024-11-01T00:00:00.000000"},
        %{"count" => 1, "date" => "2024-12-01T00:00:00.000000"},
        %{"count" => 4, "date" => "2025-01-01T00:00:00.000000"}
      ] =
        json_response(conn, 200)
    end
  end

  describe("monthly income") do
    setup [:create_sold_products]

    test "works", %{conn: conn} do
      conn = get(conn, ~p"/api/sold-products/monthly-income")

      [
        %{"date" => "2024-11-01T00:00:00.000000", "income" => 69.98},
        %{"date" => "2024-12-01T00:00:00.000000", "income" => 29.99},
        %{"date" => "2025-01-01T00:00:00.000000", "income" => 54.96}
      ] =
        json_response(conn, 200)
    end
  end

  defp create_sold_products(_) do
    categories =
      @sample_categories
      |> Enum.map(fn category -> categories_to_sold_products_fixture(category) end)

    %{categories: categories}
  end
end
