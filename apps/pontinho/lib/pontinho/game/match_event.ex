defmodule Pontinho.MatchEvent do
  @moduledoc """
  Match event schema
  """

  use Ecto.Schema

  alias Pontinho.{Match, MatchCollection, MatchPlayer}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :naive_datetime_usec]

  schema "match_events" do
    field :cards, {:array, :map}
    field :type, :string
    field :taked_card, :map
    belongs_to :match, Match
    belongs_to :match_player, MatchPlayer
    belongs_to :match_collection, MatchCollection

    timestamps()
  end
end
