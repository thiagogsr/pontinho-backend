defmodule Pontinho.Event.Buy do
  @moduledoc """
  Buy event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Deck, UpdateMatch, UpdateMatchPlayer}

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

  def run(match, match_player, _match_collection, _cards) do
    {card, stock} = Deck.buy(match.stock)
    UpdateMatch.run(match, %{stock: stock})
    UpdateMatchPlayer.run(match_player, %{hand: [card | match_player.hand]})
  end
end
