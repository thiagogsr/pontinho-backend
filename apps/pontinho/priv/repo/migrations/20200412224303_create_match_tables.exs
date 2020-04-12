defmodule Pontinho.Repo.Migrations.CreateMatchTables do
  use Ecto.Migration

  def change do
    create table(:match_tables, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cards, {:array, :map}, null: false
      add :trash, {:array, :map}, null: false
      add :first_card, :map, null: false
      add :match_id, references(:matches, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:match_tables, [:match_id])
  end
end
