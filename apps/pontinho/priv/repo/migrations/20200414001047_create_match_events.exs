defmodule Pontinho.Repo.Migrations.CreateMatchEvents do
  use Ecto.Migration

  def change do
    create table(:match_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false
      add :cards, {:array, :map}, null: false
      add :match_id, references(:matches, on_delete: :nothing, type: :binary_id), null: false
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:match_events, [:match_id])
  end
end
