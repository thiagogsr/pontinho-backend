defmodule Pontinho.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :sequence, :integer, null: false
      add :points, :integer, null: false
      add :broke_times, :integer, null: false
      add :playing, :boolean, null: false
      add :balance, :integer
      add :game_id, references(:games, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:players, [:game_id])
    create unique_index(:players, [:game_id, :name])

    alter table(:games) do
      add :winner_id, references(:players, on_delete: :nothing, type: :binary_id)
    end

    create index(:games, [:winner_id])
  end
end
