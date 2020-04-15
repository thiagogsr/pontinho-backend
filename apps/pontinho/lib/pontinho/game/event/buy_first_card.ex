defmodule Pontinho.Event.BuyFirstCard do
  @moduledoc """
  Buy first card event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Deck, UpdateMatch, UpdateMatchPlayer}

  def validate(_match, _match_player, _match_collection, _cards, previous_event) do
    case previous_event do
      nil -> []
      _ -> ["invalid operation"]
    end
  end

  def run(match, match_player, _match_collection, _cards) do
    {card, stock} = Deck.buy(match.stock)
    UpdateMatch.run(match, %{stock: stock})
    UpdateMatchPlayer.run(match_player, %{first_card: card})
  end
end
