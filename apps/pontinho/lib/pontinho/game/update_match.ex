defmodule Pontinho.UpdateMatch do
  @moduledoc """
  Match update
  """

  import Ecto.Changeset

  alias Pontinho.{Match, Repo}

  @spec run(%Match{}, map) :: {:ok, %Match{}}
  def run(match, attributes) do
    match
    |> cast(attributes, [:stock, :discard_pile])
    |> Repo.update()
  end
end
