defmodule Pontinho.Collection do
  @moduledoc """
  Collection validator
  """

  alias Pontinho.{CollectionWithJoker, CollectionWithoutJoker, Deck}

  @doc """
  It requires at least 3 cards to be a valid collection.

  The validation is different if the collection has joker or not.
  """
  @spec validate(list(map), map, boolean) :: {:ok, %{type: String.t()}} | {:error, String.t()}
  def validate(cards, _joker, _beat) when length(cards) < 3 do
    {:error, "at least 3 cards"}
  end

  def validate(cards, joker, beat) do
    {cards_except_joker_values_length, _} =
      cards
      |> Enum.reject(&(&1["value"] == joker["value"] && &1["suit"] == joker["suit"]))
      |> count_cards_attributes()

    {cards_values_length, cards_suits_length} = count_cards_attributes(cards)

    if Deck.member?(cards, joker) do
      CollectionWithJoker.validate(
        cards,
        cards_except_joker_values_length,
        cards_values_length,
        cards_suits_length,
        joker,
        beat
      )
    else
      CollectionWithoutJoker.validate(cards, cards_values_length, cards_suits_length)
    end
  end

  defp count_cards_attributes(cards) do
    {cards_values, cards_suits} =
      Enum.reduce(cards, {[], []}, fn card, {cards_values, cards_suits} ->
        {[card["value"] | cards_values], [card["suit"] | cards_suits]}
      end)

    {count_unique_values(cards_values), count_unique_values(cards_suits)}
  end

  defp count_unique_values(values) do
    values
    |> Enum.uniq()
    |> length()
  end
end
