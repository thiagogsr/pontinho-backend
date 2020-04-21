defmodule Pontinho.Player do
  @moduledoc """
  Player schema
  """

  use Ecto.Schema

  alias Pontinho.Game

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "players" do
    field :broke_times, :integer
    field :name, :string
    field :playing, :boolean
    field :points, :integer
    field :sequence, :integer
    field :balance, :integer
    belongs_to :game, Game

    timestamps()
  end
end
