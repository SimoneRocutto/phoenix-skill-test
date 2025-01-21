defmodule ServerWeb.DataUtilsTest do
  use ServerWeb.ConnCase
  use ExUnit.Case, async: true

  alias Server.DataUtils

  describe "sorting" do
    test "format_sort_query_param works", %{} do
      {:ok, []} =
        DataUtils.format_sort_query_param("", Server.Clients.Client)

      {:ok, [asc: :first_name, asc: :last_name]} =
        DataUtils.format_sort_query_param("first_name,last_name", Server.Clients.Client)

      # Desc sort
      {:ok, [asc: :first_name, desc: :last_name]} =
        DataUtils.format_sort_query_param("first_name,-last_name", Server.Clients.Client)

      # Order matters
      {:ok, [asc: :last_name, asc: :first_name]} =
        DataUtils.format_sort_query_param("last_name,first_name", Server.Clients.Client)

      {:error, :non_existing_field, _} =
        DataUtils.format_sort_query_param("last_name,asdjfosja", Server.Clients.Client)
    end
  end

  describe "filtering" do
    test "format_filter_query_param works", %{} do
      {:ok, [first_name: "a", last_name: "b"]} =
        DataUtils.format_filter_query_param(
          %{"first_name" => "a", "last_name" => "b"},
          Server.Clients.Client
        )

      {:error, :non_existing_field, _} =
        DataUtils.format_filter_query_param(
          %{"asdfjoji" => "a", "last_name" => "b"},
          Server.Clients.Client
        )
    end
  end
end
