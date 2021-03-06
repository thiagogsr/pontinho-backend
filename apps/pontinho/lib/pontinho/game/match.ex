defmodule Pontinho.Match do
  @moduledoc """
  Match schema
  """

  use Ecto.Schema

  alias Pontinho.{Game, MatchCollection, MatchPlayer, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "matches" do
    field :stock, {:array, :map}
    field :discard_pile, {:array, :map}
    field :pre_joker, :map
    field :joker, :map
    belongs_to :game, Game
    belongs_to :croupier, Player
    belongs_to :winner, MatchPlayer
    has_many :match_players, MatchPlayer
    has_many :match_collections, MatchCollection

    timestamps()
  end
end
