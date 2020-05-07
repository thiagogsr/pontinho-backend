defmodule Pontinho.Game do
  @moduledoc """
  Game schema
  """

  use Ecto.Schema

  alias Pontinho.{Match, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "games" do
    field :betting_table, {:array, :integer}
    belongs_to :winner, Player
    has_many :players, Player
    has_many :matches, Match

    timestamps()
  end
end
