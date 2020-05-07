defmodule Pontinho.Repo.Migrations.CreateMatchPlayers do
  use Ecto.Migration

  def change do
    create table(:match_players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :hand, {:array, :map}, null: false
      add :first_card, :map
      add :discard_pile_card, :map
      add :ask_beat, :boolean
      add :false_beat, :boolean
      add :points_before, :integer
      add :points, :integer
      add :broke, :boolean
      add :match_id, references(:matches, on_delete: :nothing, type: :binary_id), null: false
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:match_players, [:match_id, :player_id])

    alter table(:matches) do
      add :winner_id, references(:match_players, on_delete: :nothing, type: :binary_id)
    end

    create index(:matches, [:winner_id])
  end
end
