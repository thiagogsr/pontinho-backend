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

      assert %{"value" => _, "suit" => _} = card
      assert length(stock) == 103
    end
  end

  describe "remove_cards/2" do
    test "returns the cards except the cards to be taked" do
      deck = CreateDeck.run()

      cards_to_be_taked = [
        %{"value" => "2", "suit" => "diamonds", "deck" => 1},
        %{"value" => "J", "suit" => "spades", "deck" => 1}
      ]

      stock = Deck.remove_cards(deck, cards_to_be_taked)

      assert length(stock) == 102

      assert Enum.filter(stock, &(&1 == %{"value" => "2", "suit" => "diamonds", "deck" => 1})) ==
               []

      assert Enum.filter(stock, &(&1 == %{"value" => "J", "suit" => "spades", "deck" => 1})) == []
      assert Enum.count(stock, &(&1 == %{"value" => "2", "suit" => "diamonds", "deck" => 2})) == 1
      assert Enum.count(stock, &(&1 == %{"value" => "J", "suit" => "spades", "deck" => 2})) == 1
    end
  end

  describe "value_index/1" do
    test "returns the value index" do
      assert Deck.value_index("J") == 10
    end
  end

  describe "next_card/1" do
    test "returns ACE when the card is a KING" do
      assert %{"value" => "A", "suit" => "hearts", "deck" => 1} =
               Deck.next_card(%{"value" => "K", "suit" => "hearts", "deck" => 1})
    end

    test "returns the next card for any else" do
      assert %{"value" => "2", "suit" => "diamonds", "deck" => 1} =
               Deck.next_card(%{"value" => "A", "suit" => "diamonds", "deck" => 1})
    end
  end

  describe "replace_card/3" do
    test "replaces the old card by the new card" do
      old_card = %{"value" => "2", "suit" => "diamonds", "deck" => 1}
      new_card = %{"value" => "10", "suit" => "hearts", "deck" => 2}

      cards = [
        %{"value" => "9", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "diamonds", "deck" => 1},
        %{"value" => "J", "suit" => "hearts", "deck" => 2}
      ]

      assert Deck.replace_card(cards, old_card, new_card) ==
               [
                 %{"value" => "9", "suit" => "hearts", "deck" => 1},
                 %{"value" => "10", "suit" => "hearts", "deck" => 2},
                 %{"value" => "J", "suit" => "hearts", "deck" => 2}
               ]
    end

    test "returns the same cards when replacement is not found" do
      old_card = %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      new_card = %{"value" => "10", "suit" => "hearts", "deck" => 2}

      cards = [
        %{"value" => "9", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "diamonds", "deck" => 1},
        %{"value" => "J", "suit" => "hearts", "deck" => 1}
      ]

      assert Deck.replace_card(cards, old_card, new_card) ==
               [
                 %{"value" => "9", "suit" => "hearts", "deck" => 1},
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1},
                 %{"value" => "J", "suit" => "hearts", "deck" => 1}
               ]
    end
  end
end
