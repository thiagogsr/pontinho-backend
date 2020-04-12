defmodule Pontinho.Deck do
  @moduledoc """
  Deck
  """

  @spec take_random_cards(list(map), integer) :: {list(map), list(map)}
  def take_random_cards(cards, quantity) do
    taked_cards = Enum.take_random(cards, quantity)
    rest_cards = cards -- taked_cards
    {taked_cards, rest_cards}
  end
end
