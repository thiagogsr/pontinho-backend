defmodule Pontinho.Event.AddCardToCollection do
  @moduledoc """
  Adding a card to a collection
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Collection, Deck, UpdateMatchCollection, UpdateMatchPlayer}

  def validate(match, match_player, _match_collection, cards, previous_event) do
    if validate_match_player(match_player, previous_event) &&
         validate_match_player_hand(match_player.hand, cards, previous_event) &&
         validate_operation(match, cards, previous_event) do
      case Collection.validate(cards, match.joker, previous_event.type == "ASK_BEAT") do
        {:ok, _} -> []
        {:error, error} -> [error]
      end
    else
      ["invalid operation"]
    end
  end

  defp validate_match_player(match_player, previous_event) do
    previous_event.match_player_id == match_player.id
  end

  defp validate_match_player_hand(_match_player_hand, _cards, %{type: "ASK_BEAT"}), do: true

  defp validate_match_player_hand(match_player_hand, cards, _previous_event) do
    case Deck.remove_cards(match_player_hand, cards) do
      c when length(c) == 1 -> false
      _ -> true
    end
  end

  defp validate_operation(match, cards, previous_event) do
    cond do
      previous_event.type == "REPLACE_JOKER" && Deck.member?(cards, match.joker) ->
        true

      previous_event.type == "TAKE_DISCARD_PILE" && previous_event.taked_card in cards ->
        true

      previous_event.type in ["BUY", "ASK_BEAT", "ADD_CARD_TO_COLLECTION", "DROP_COLLECTION"] ->
        true

      true ->
        false
    end
  end

  def run(_match, match_player, match_collection, cards, _previous_event) do
    new_match_collection_cards = Deck.remove_cards(cards, match_collection.cards)
    match_player_cards = Deck.remove_cards(match_player.hand, new_match_collection_cards)

    UpdateMatchPlayer.run(match_player, %{hand: match_player_cards})
    UpdateMatchCollection.run(match_collection, %{cards: cards})
  end
end
