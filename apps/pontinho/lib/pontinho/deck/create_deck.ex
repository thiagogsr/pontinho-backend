defmodule Pontinho.CreateDeck do
  @moduledoc """
  Create the deck necessary for the game
  """

  alias Pontinho.{Deck, ShuffleCards}

  @spec run() :: list(map)
  def run do
    Deck.values()
    |> Enum.map(fn value ->
      Enum.map(Deck.suits(), fn suit ->
        [%{"value" => value, "suit" => suit}, %{"value" => value, "suit" => suit}]
      end)
    end)
    |> List.flatten()
    |> ShuffleCards.run()
  end
end
