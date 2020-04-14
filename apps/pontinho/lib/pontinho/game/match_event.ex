defmodule Pontinho.MatchEvent do
  @moduledoc """
  Match event schema
  """

  use Ecto.Schema

  alias Pontinho.{Match, MatchPlayer}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "match_events" do
    field :cards, {:array, :map}
    field :type, :string
    belongs_to :match, Match
    belongs_to :match_player, MatchPlayer

    timestamps()
  end
end
