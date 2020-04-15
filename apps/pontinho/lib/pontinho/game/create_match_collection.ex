defmodule Pontinho.CreateMatchCollection do
  @moduledoc """
  Creating a match collection
  """

  import Ecto.Changeset

  alias Pontinho.{Match, MatchCollection, MatchPlayer, Repo}

  @spec run(%Match{}, %MatchPlayer{}, String.t(), list(map)) ::
          {:ok, %MatchCollection{}} | {:error, %Ecto.Changeset{}}
  def run(match, match_player, type, cards) do
    %MatchCollection{}
    |> cast(%{type: type, cards: cards}, [:cards, :type])
    |> validate_length(:cards, min: 3)
    |> put_assoc(:match, match)
    |> put_assoc(:dropped_by, match_player)
    |> Repo.insert()
  end
end
