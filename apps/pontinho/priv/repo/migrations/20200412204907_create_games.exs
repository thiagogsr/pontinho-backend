defmodule Pontinho.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string, null: false
      add :betting_table, {:array, :integer}, null: false

      timestamps()
    end
  end
end
