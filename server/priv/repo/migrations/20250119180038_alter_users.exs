defmodule Server.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :username, :string, null: false
      modify :password, :string, null: false
    end

    create unique_index(:users, :username)
  end

  def down do
    alter table(:users) do
      modify :username, :string, null: true
      modify :password, :string, null: true
    end

    drop unique_index(:users, :username)
  end
end
