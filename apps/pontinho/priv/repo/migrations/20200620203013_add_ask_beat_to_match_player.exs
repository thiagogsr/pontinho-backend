defmodule Pontinho.Repo.Migrations.AddAskBeatToMatchPlayer do
  use Ecto.Migration

  def change do
    alter table(:match_players) do
      add(:asked_beat, :boolean)
    end

    execute("update match_players set asked_beat = false")

    alter table(:match_players) do
      modify(:asked_beat, :boolean, null: false)
    end
  end
end
