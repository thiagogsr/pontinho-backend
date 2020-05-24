defmodule Pontinho.Event.ReplaceJoker do
  @moduledoc """
  Replacing joker event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Collection, Deck, UpdateMatchCollection, UpdateMatchPlayer}

  def validate(match, match_player, match_collection, cards, previous_event) do
    [card | _tail] = cards
    match_collection_cards = Deck.replace_card(match_collection.cards, match.joker, card)

    with true <- previous_event.match_player_id == match_player.id,
         true <- Deck.member?(match_collection.cards, match.joker),
         {:ok, _} <- Collection.validate(match_collection_cards, match.joker, false),
         %{type: type}
         when type in ["BUY", "ASK_BEAT", "DROP_COLLECTION", "ADD_CARD_TO_COLLECTION"] <-
           previous_event do
      []
    else
      _ -> ["invalid operation"]
    end
  end

  def run(match, match_player, match_collection, cards, _previous_event) do
    [card | _tail] = cards
    replaced_card = Deck.find_card(match_collection.cards, match.joker)
    match_player_cards = [replaced_card | Deck.remove_cards(match_player.hand, [card])]
    match_collection_cards = Deck.replace_card(match_collection.cards, replaced_card, card)

    UpdateMatchPlayer.run(match_player, %{hand: match_player_cards})
    UpdateMatchCollection.run(match_collection, %{cards: match_collection_cards})
  end
end
