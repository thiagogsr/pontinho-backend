defmodule Pontinho.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :stock, {:array, :map}, null: false
      add :discard_pile, {:array, :map}, null: false
      add :pre_joker, :map, null: false
      add :joker, :map, null: false
      add :game_id, references(:games, on_delete: :nothing, type: :binary_id), null: false
      add :croupier_id, references(:players, on_delete: :nothing, type: :binary_id), null: false
      add :winner_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:matches, [:game_id])
    create index(:matches, [:croupier_id])
    create index(:matches, [:winner_id])
  end
end
