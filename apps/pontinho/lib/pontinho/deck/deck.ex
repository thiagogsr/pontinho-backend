defmodule Pontinho.Deck do
  @moduledoc """
  Deck
  """

  @values ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  @suits ["clubs", "diamonds", "hearts", "spades"]

  @spec values :: list(String.t())
  def values, do: @values

  @spec suits :: list(String.t())
  def suits, do: @suits

  @spec take_random_cards(list(map), integer) :: {list(map), list(map)}
  def take_random_cards(cards, quantity) do
    taked_cards = Enum.take_random(cards, quantity)
    rest_cards = take_cards(cards, taked_cards)
    {taked_cards, rest_cards}
  end

  @spec buy(list(map)) :: {map, list(map)}
  def buy(cards) do
    [card | deck] = cards
    {card, deck}
  end

  @spec take_cards(list(map), list(map)) :: list(map)
  def take_cards(cards, cards_to_be_taked) do
    cards -- cards_to_be_taked
  end

  @spec value_index(String.t()) :: non_neg_integer
  def value_index(value) do
    Enum.find_index(@values, &(&1 == value))
  end
end
