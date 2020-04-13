defmodule Pontinho.Game do
  @moduledoc """
  Game schema
  """

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "games" do
    field :betting_table, {:array, :integer}

    timestamps()
  end
end
