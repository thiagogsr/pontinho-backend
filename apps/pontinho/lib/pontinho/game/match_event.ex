defmodule Pontinho.MatchEvent do
  @moduledoc """
  Match event schema
  """

  use Ecto.Schema

  alias Pontinho.{Match, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "match_events" do
    field :cards, {:array, :map}
    field :type, :string
    belongs_to :match, Match
    belongs_to :player, Player

    timestamps()
  end
end
