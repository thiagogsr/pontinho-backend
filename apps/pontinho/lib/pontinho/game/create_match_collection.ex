defmodule Pontinho.CreateMatchCollection do
  @moduledoc """
  Creating a match collection
  """

  import Ecto.Changeset

  alias Pontinho.{Match, MatchCollection, MatchPlayer, Repo}

  @spec run(%Match{}, %MatchPlayer{}, String.t(), list(map)) ::
          {:ok, %MatchCollection{}} | {:error, %Ecto.Changeset{}}
  def run(match, match_player, type, cards) do
    cards = add_order_to_cards(cards)

    %MatchCollection{}
    |> cast(%{type: type, cards: cards}, [:cards, :type])
    |> validate_length(:cards, min: 3)
    |> put_assoc(:match, match)
    |> put_assoc(:dropped_by, match_player)
    |> Repo.insert()
  end

  defp add_order_to_cards(cards) do
    cards
    |> Enum.with_index()
    |> Enum.map(fn {card, index} ->
      Map.put(card, "order", index)
    end)
  end
end
