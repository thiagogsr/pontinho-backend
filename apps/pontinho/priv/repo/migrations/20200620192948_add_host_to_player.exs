defmodule Pontinho.Repo.Migrations.AddHostToPlayer do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add(:host, :boolean)
    end

    execute("update players set host = false")

    alter table(:players) do
      modify(:host, :boolean, null: false)
    end
  end
end
