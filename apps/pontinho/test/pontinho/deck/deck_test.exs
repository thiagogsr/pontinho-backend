defmodule Pontinho.DeckTest do
  use ExUnit.Case, async: true

  alias Pontinho.{CreateDeck, Deck}

  describe "values/0" do
    test "returns the values" do
      assert Deck.values() == ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    end
  end

  describe "suits/0" do
    test "returns the suits" do
      assert Deck.suits() == ["clubs", "diamonds", "hearts", "spades"]
    end
  end

  describe "take_random_cards/2" do
    test "returns the taked and rest of cards" do
      deck = CreateDeck.run()
      {cards, stock} = Deck.take_random_cards(deck, 3)

      assert length(cards) == 3
      assert length(stock) == 101
    end
  end

  describe "buy/1" do
    test "returns the first card and the rest of cards" do
      deck = CreateDeck.run()
      {card, stock} = Deck.buy(deck)

      assert %{value: _, suit: _} = card
      assert length(stock) == 103
    end
  end

  describe "take_cards/2" do
    test "returns the cards except the cards to be taked" do
      deck = CreateDeck.run()
      cards_to_be_taked = [%{value: "2", suit: "diamonds"}, %{value: "J", suit: "spades"}]
      stock = Deck.take_cards(deck, cards_to_be_taked)

      assert length(stock) == 102
      assert Enum.count(stock, &(&1 == %{value: "2", suit: "diamonds"})) == 1
      assert Enum.count(stock, &(&1 == %{value: "J", suit: "spades"})) == 1
    end
  end

  describe "value_index/1" do
    test "returns the value index" do
      assert Deck.value_index("J") == 10
    end
  end
end
