defmodule Pontinho.DeckTest do
  use ExUnit.Case, async: true

  alias Pontinho.{CreateDeck, Deck}

  describe "take_random_cards/2" do
    test "returns the taked and rest of cards" do
      cards = CreateDeck.run()
      {taked_cards, rest_cards} = Deck.take_random_cards(cards, 3)

      assert length(taked_cards) == 3
      assert length(rest_cards) == 101
    end
  end
end
