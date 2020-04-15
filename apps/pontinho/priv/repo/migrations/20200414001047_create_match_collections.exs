defmodule Pontinho.Repo.Migrations.CreateMatchCollections do
  use Ecto.Migration

  def change do
    create table(:match_collections, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false
      add :cards, {:array, :map}, null: false
      add :match_id, references(:matches, on_delete: :nothing, type: :binary_id), null: false

      add :dropped_by_id, references(:match_players, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:match_collections, [:match_id])
    create index(:match_collections, [:dropped_by_id])
  end
end
