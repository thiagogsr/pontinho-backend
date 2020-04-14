defmodule Pontinho.Match do
  @moduledoc """
  Match schema
  """

  use Ecto.Schema

  alias Pontinho.{Game, MatchPlayer, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "matches" do
    field :stock, {:array, :map}
    field :discard_pile, {:array, :map}
    field :joker, :map
    field :first_card, :map
    belongs_to :game, Game
    belongs_to :croupier, Player
    has_many :match_players, MatchPlayer

    timestamps()
  end
end
