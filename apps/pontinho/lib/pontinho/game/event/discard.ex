defmodule Pontinho.Event.Discard do
  @moduledoc """
  Discard event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Deck, UpdateMatch, UpdateMatchPlayer}

  def validate(match, match_player, _match_collection, cards, previous_event) do
    [card] = cards

    cond do
      Deck.member?([card], match.joker) ->
        ["you cannot discard the joker"]

      !is_nil(previous_event) && previous_event.match_player_id == match_player.id &&
        card in match_player.hand &&
          previous_event.type in [
            "DROP_COLLECTION",
            "ADD_CARD_TO_COLLECTION",
            "BUY",
            "ACCEPT_FIRST_CARD"
          ] ->
        []

      true ->
        ["invalid operation"]
    end
  end

  def run(match, match_player, _match_collection, cards, _previous_event) do
    [card] = cards
    match_player_cards = Deck.remove_cards(match_player.hand, [card])

    UpdateMatch.run(match, %{discard_pile: [card | match.discard_pile]})
    UpdateMatchPlayer.run(match_player, %{hand: match_player_cards})
  end
end
