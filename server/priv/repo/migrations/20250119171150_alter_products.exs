defmodule Server.Repo.Migrations.AlterProducts do
  use Ecto.Migration

  def up do
    alter table(:products) do
      modify :name, :string, null: false
      modify :price, :decimal, null: false
      modify :category_id, :id, null: false
    end
  end

  def down do
    alter table(:products) do
      modify :name, :string, null: true
      modify :price, :decimal, null: true
      modify :category_id, :id, null: true
    end
  end
end
