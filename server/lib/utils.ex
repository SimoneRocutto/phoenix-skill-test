defmodule Utils do
  def coalesce(value, default) do
    if value === nil do
      default
    else
      value
    end
  end
end
