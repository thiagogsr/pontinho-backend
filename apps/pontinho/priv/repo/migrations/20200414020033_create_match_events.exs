defmodule Pontinho.Repo.Migrations.CreateMatchEvents do
  use Ecto.Migration

  def change do
    create table(:match_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false
      add :cards, {:array, :map}, null: false
      add :taked_card, :map
      add :match_id, references(:matches, on_delete: :nothing, type: :binary_id), null: false

      add :match_player_id, references(:match_players, on_delete: :nothing, type: :binary_id),
        null: false

      add :match_collection_id,
          references(:match_collections, on_delete: :nothing, type: :binary_id)

      timestamps(type: :naive_datetime_usec)
    end

    create index(:match_events, [:match_id])
  end
end
