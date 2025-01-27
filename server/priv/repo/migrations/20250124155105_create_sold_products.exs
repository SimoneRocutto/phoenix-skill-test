defmodule Server.Repo.Migrations.CreateSoldProducts do
  use Ecto.Migration

  def change do
    create table(:sold_products) do
      add :selling_time, :utc_datetime, null: false
      add :product_id, references(:products, on_delete: :nothing), null: false
      add :client_id, references(:clients, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:sold_products, [:product_id])
    create index(:sold_products, [:client_id])
  end
end
