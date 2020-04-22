defmodule Pontinho.ShuffleCardsTest do
  use ExUnit.Case, async: true

  alias Pontinho.{CreateDeck, ShuffleCards}

  test "returns shuffled cards" do
    deck = CreateDeck.run()
    cards = ShuffleCards.run(deck, 5)

    assert deck -- cards == []
    assert Enum.at(deck, 23) != Enum.at(cards, 23)
  end
end
