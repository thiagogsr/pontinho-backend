defmodule PontinhoWeb.MatchPlayerSerializerTest do
  use ExUnit.Case, async: true

  import Pontinho.Factory

  alias PontinhoWeb.MatchPlayerSerializer

  describe "serialize/1" do
    test "returns a serialized match player with previous_event's type equals to ASK_BEAT" do
      match_player = build(:match_player)
      match_event = build(:match_event, type: "ASK_BEAT")

      assert %{
               match_player_id: _,
               match_player_hand: match_player_hand,
               asked_beat: true,
               taked_card: nil
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event
               })

      assert is_list(match_player_hand)
      assert length(match_player_hand) == 9
    end

    test "returns a serialized match player with previous_event's type equals to BUY_FIRST_CARD" do
      match_player = build(:match_player)

      match_event =
        build(:match_event,
          type: "BUY_FIRST_CARD",
          taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
        )

      assert %{
               match_player_id: _,
               match_player_hand: match_player_hand,
               asked_beat: false,
               taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event
               })

      assert is_list(match_player_hand)
      assert length(match_player_hand) == 9
    end

    test "returns a serialized match player without previous_event" do
      match_player = build(:match_player)

      assert %{
               match_player_id: _,
               match_player_hand: match_player_hand,
               asked_beat: false,
               taked_card: nil
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: nil
               })

      assert is_list(match_player_hand)
      assert length(match_player_hand) == 9
    end
  end
end
