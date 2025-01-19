defmodule Server.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :phone_number, :string
      add :location, :string
      add :hobby, :string

      timestamps(type: :utc_datetime)
    end
  end
end
