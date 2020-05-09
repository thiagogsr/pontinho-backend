defmodule Pontinho.Event.Buy do
  @moduledoc """
  Buy event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Deck, ShuffleCards, UpdateMatch, UpdateMatchPlayer}

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    %{id: match_player_id} = match_player

    case previous_event do
      %{type: "DISCARD", match_player_id: previous_match_player_id}
      when previous_match_player_id != match_player_id ->
        []

      %{type: "REJECT_FIRST_CARD", match_player_id: previous_match_player_id}
      when previous_match_player_id == match_player_id ->
        []

      _ ->
        ["invalid operation"]
    end
  end

  def run(match, match_player, _match_collection, _cards, _previous_event) do
    {card, stock} = Deck.buy(match.stock)

    case length(stock) do
      0 ->
        new_stock = ShuffleCards.run(match.discard_pile)
        UpdateMatch.run(match, %{stock: new_stock, discard_pile: []})

      _ ->
        UpdateMatch.run(match, %{stock: stock})
    end

    UpdateMatchPlayer.run(match_player, %{hand: [card | match_player.hand]})
  end
end
