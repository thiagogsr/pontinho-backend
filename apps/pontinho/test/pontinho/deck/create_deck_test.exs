defmodule Pontinho.CreateDeckTest do
  use ExUnit.Case, async: true

  alias Pontinho.CreateDeck

  test "returns two decks" do
    deck = CreateDeck.run()
    assert length(deck) == 104

    assert Enum.count(deck, fn %{value: value, suit: suit} ->
             value == "A" && suit == "spades"
           end) == 2
  end
end
