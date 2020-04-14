defmodule Pontinho.MatchPlayer do
  @moduledoc """
  Match player schema
  """

  use Ecto.Schema

  alias Pontinho.{Match, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "match_players" do
    field :hand, {:array, :map}
    belongs_to :match, Match
    belongs_to :player, Player

    timestamps()
  end
end
