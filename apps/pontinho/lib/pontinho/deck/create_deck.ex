defmodule Pontinho.CreateDeck do
  @moduledoc """
  Create the deck necessary for the game
  """

  alias Pontinho.{Deck, ShuffleCards}

  @spec run() :: list(map)
  def run do
    Deck.values()
    |> Enum.flat_map(fn value ->
      Enum.flat_map(Deck.suits(), fn suit ->
        [
          %{"value" => value, "suit" => suit, "deck" => 1},
          %{"value" => value, "suit" => suit, "deck" => 2}
        ]
      end)
    end)
    |> ShuffleCards.run()
  end
end
