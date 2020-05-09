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
    field :false_beat, :boolean
    field :points_before, :integer
    field :points, :integer
    field :broke, :boolean
    belongs_to :match, Match
    belongs_to :player, Player

    timestamps()
  end
end
