defmodule Pontinho.MatchTable do
  @moduledoc """
  Match table schema
  """

  use Ecto.Schema

  alias Pontinho.Match

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "match_tables" do
    field :cards, {:array, :map}
    field :first_card, :map
    field :trash, {:array, :map}
    belongs_to :match, Match

    timestamps()
  end
end
