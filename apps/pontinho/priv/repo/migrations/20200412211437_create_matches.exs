defmodule Pontinho.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :joker, :map, null: false
      add :cards, {:array, :map}, null: false
      add :game_id, references(:games, on_delete: :nothing, type: :binary_id), null: false
      add :croupier_id, references(:players, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:matches, [:game_id])
    create index(:matches, [:croupier_id])
  end
end
