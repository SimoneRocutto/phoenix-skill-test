defmodule Server.Repo.Migrations.AlterClients do
  use Ecto.Migration

  def up do
    alter table(:clients) do
      modify :first_name, :string, null: false
      modify :last_name, :string, null: false
      modify :email, :string, null: false
    end

    create unique_index(:clients, :email)
  end

  def down do
    alter table(:clients) do
      modify :first_name, :string, null: true
      modify :last_name, :string, null: true
      modify :email, :string, null: true
    end

    drop unique_index(:clients, :email)
  end
end
