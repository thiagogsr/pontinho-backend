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
    |> update_change(:cards, &add_order_to_cards/1)
    |> Repo.update()
  end

  defp add_order_to_cards(cards) when is_list(cards) do
    cards
    |> Enum.with_index()
    |> Enum.map(fn {card, index} ->
      Map.put(card, "order", index)
    end)
  end

  defp add_order_to_cards(cards), do: cards
end
