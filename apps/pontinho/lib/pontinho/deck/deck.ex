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
    stock = remove_cards(cards, taked_cards)
    {taked_cards, stock}
  end

  @spec buy(list(map)) :: {map, list(map)}
  def buy(cards) do
    [card | stock] = cards
    {card, stock}
  end

  @spec remove_cards(list(map), list(map)) :: list(map)
  def remove_cards(cards, cards_to_be_taked) do
    cards -- cards_to_be_taked
  end

  @spec value_index(String.t()) :: non_neg_integer
  def value_index(value) do
    Enum.find_index(@values, &(&1 == value))
  end

  @spec next_card(map) :: map()
  def next_card(%{value: value, suit: suit}) do
    last_index = Enum.count(@values) - 1

    next_index =
      case value_index(value) do
        ^last_index -> 0
        index -> index + 1
      end

    next_value = Enum.at(@values, next_index)
    %{value: next_value, suit: suit}
  end

  @spec replace_card(list(map), map, map) :: list(map)
  def replace_card(cards, old_card, new_card) do
    case Enum.find_index(cards, &(&1 == old_card)) do
      nil -> cards
      index -> List.replace_at(cards, index, new_card)
    end
  end
end
