defmodule Server.Repo.Migrations.AlterCategories do
  use Ecto.Migration

  def up do
    alter table(:categories) do
      modify :name, :string, null: false
    end
  end

  def down do
    alter table(:categories) do
      modify :name, :string, null: true
    end
  end
end
