defmodule Pontinho.UpdateMatchCollection do
  @moduledoc """
  Updating a match collection
  """

  import Ecto.Changeset

  alias Pontinho.{MatchCollection, Repo}

  @spec run(%MatchCollection{}, map) :: {:ok, %MatchCollection{}}
  def run(match_collection, attributes) do
    match_collection
    |> cast(attributes, [:cards])
    |> Repo.update()
  end
end
