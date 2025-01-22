defmodule Server.Repo.Migrations.AlterProductsPriceType do
  use Ecto.Migration

  def up do
    alter table(:products) do
      modify :price, :float, null: false
    end
  end

  def down do
    alter table(:products) do
      modify :price, :decimal, null: false
    end
  end
end
