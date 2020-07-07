defmodule PontinhoWeb.MatchPlayerSerializer do
  @moduledoc """
  Match player serialization
  """

  @spec serialize(map) :: map
  def serialize(%{
        match_player: match_player,
        round_match_player: round_match_player,
        previous_event: previous_event
      })
      when is_nil(previous_event) do
    my_time = match_player.id == round_match_player.id

    %{
      match_player_id: match_player.id,
      match_player_hand: match_player.hand,
      taked_card: nil,
      abilities: %{
        add_card_to_collection: false,
        answer_first_card: false,
        ask_beat: false,
        beat: false,
        buy: false,
        buy_first_card: my_time,
        discard: false,
        drop_collection: false,
        false_beat: false,
        replace_joker: false,
        take_discard_pile: false
      }
    }
  end

  def serialize(%{
        match_player: match_player,
        round_match_player: round_match_player,
        previous_event: previous_event
      }) do
    my_time = match_player.id == round_match_player.id

    %{
      match_player_id: match_player.id,
      match_player_hand: match_player.hand,
      taked_card: previous_event.taked_card,
      abilities: %{
        add_card_to_collection:
          add_card_to_collection_ability(my_time, match_player, previous_event),
        answer_first_card: answer_first_card_ability(my_time, previous_event),
        ask_beat: ask_beat_ability(my_time, match_player, previous_event),
        beat: beat_ability(my_time, match_player),
        buy: buy_ability(my_time, previous_event),
        buy_first_card: false,
        discard: discard_ability(my_time, match_player, previous_event),
        drop_collection: drop_collection_ability(my_time, match_player, previous_event),
        false_beat: false_beat_abiluty(my_time, match_player, previous_event),
        replace_joker: replace_joker_ability(my_time, match_player, previous_event),
        take_discard_pile: take_discard_pile_ability(my_time, match_player, previous_event)
      }
    }
  end

  defp add_card_to_collection_ability(my_time, match_player, previous_event) do
    my_time &&
      length(match_player.hand) > 0 &&
      previous_event.type not in ["BUY_FIRST_CARD", "REJECT_FIRST_CARD"]
  end

  defp answer_first_card_ability(my_time, previous_event) do
    my_time && previous_event.type == "BUY_FIRST_CARD"
  end

  defp ask_beat_ability(my_time, match_player, previous_event) do
    previous_event.type not in ["BUY_FIRST_CARD", "REJECT_FIRST_CARD"] &&
      !match_player.asked_beat &&
      (my_time ||
         (!match_player.false_beat &&
            previous_event.type == "DISCARD" &&
            length(match_player.hand) > 1))
  end

  defp beat_ability(my_time, match_player) do
    my_time && length(match_player.hand) == 0
  end

  defp buy_ability(my_time, previous_event) do
    my_time && previous_event.type in ["DISCARD", "REJECT_FIRST_CARD"]
  end

  defp discard_ability(my_time, match_player, previous_event) do
    my_time &&
      !match_player.asked_beat &&
      length(match_player.hand) > 1 &&
      previous_event.type not in [
        "DISCARD",
        "TAKE_DISCARD_PILE",
        "BUY_FIRST_CARD",
        "REJECT_FIRST_CARD"
      ]
  end

  defp drop_collection_ability(my_time, match_player, previous_event) do
    my_time &&
      length(match_player.hand) >= 3 &&
      previous_event.type not in ["BUY_FIRST_CARD", "REJECT_FIRST_CARD"]
  end

  defp false_beat_abiluty(my_time, match_player, previous_event) do
    my_time && match_player.asked_beat && previous_event.type == "ASK_BEAT"
  end

  defp replace_joker_ability(my_time, match_player, previous_event) do
    my_time &&
      length(match_player.hand) > 0 &&
      previous_event.type not in ["BUY_FIRST_CARD", "REJECT_FIRST_CARD"]
  end

  defp take_discard_pile_ability(my_time, match_player, previous_event) do
    my_time && match_player.id != previous_event.match_player_id
  end
end
