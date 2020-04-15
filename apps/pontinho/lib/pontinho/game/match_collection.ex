defmodule Pontinho.MatchCollection do
  @moduledoc """
  Match game schema
  """

  use Ecto.Schema

  alias Pontinho.{Match, MatchPlayer}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "match_collections" do
    field :cards, {:array, :map}
    field :type, :string
    belongs_to :match, Match
    belongs_to :dropped_by, MatchPlayer

    timestamps()
  end
end
