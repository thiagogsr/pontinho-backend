defmodule Pontinho.Match do
  @moduledoc """
  Match schema
  """

  use Ecto.Schema

  alias Pontinho.{Game, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "matches" do
    field :cards, {:array, :map}
    field :joker_suit, :string
    field :joker_value, :string
    belongs_to :game, Game
    belongs_to :croupier, Player

    timestamps()
  end
end
