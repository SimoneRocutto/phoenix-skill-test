defmodule Server.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :decimal
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:category_id])
  end
end
