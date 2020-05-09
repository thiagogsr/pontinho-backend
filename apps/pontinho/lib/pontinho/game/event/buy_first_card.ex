defmodule Pontinho.Event.BuyFirstCard do
  @moduledoc """
  Buy first card event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Deck, UpdateMatch}

  def validate(_match, _match_player, _match_collection, _cards, previous_event) do
    case previous_event do
      nil -> []
      _ -> ["invalid operation"]
    end
  end

  def run(match, _match_player, _match_collection, _cards, _previous_event) do
    {card, stock} = Deck.buy(match.stock)
    UpdateMatch.run(match, %{stock: stock})

    {:cast, :taked_card, card}
  end
end
