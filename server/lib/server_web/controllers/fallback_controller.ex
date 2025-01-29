defmodule ServerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ServerWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ServerWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # Resource not found
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: ServerWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :non_existing_field, field}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ServerWeb.DbErrorJSON)
    |> render(:non_existing_field, %{field: field})
  end
end
