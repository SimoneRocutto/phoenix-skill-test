defmodule ServerWeb.DbErrorJSON do
  def non_existing_field(%{field: field}) do
    %{errors: %{field => ["is not a valid column"]}}
  end
end
