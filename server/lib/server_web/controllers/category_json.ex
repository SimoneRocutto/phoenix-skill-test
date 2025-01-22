defmodule ServerWeb.CategoryJSON do
  alias Server.Products.Category
  alias Server.DataUtils

  @doc """
  Renders a list of categories.
  """
  @spec index(%{data: [%Category{}], pagination: map()}) :: %{data: [map()], pagination: map()}
  def index(raw_data) do
    DataUtils.format_index_response(raw_data, &data/1)
  end

  @doc """
  Renders a single category.
  """
  def show(%{category: category}) do
    %{data: data(category)}
  end

  defp data(%Category{} = category) do
    %{
      id: category.id,
      name: category.name
    }
  end
end
