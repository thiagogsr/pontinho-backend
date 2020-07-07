defmodule PontinhoWeb.MatchPlayerSerializerTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias PontinhoWeb.MatchPlayerSerializer

  describe "serialize/1" do
    test "returns the serialized match player when there is no previous event" do
      match_player = insert(:match_player, asked_beat: false)

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: false,
                 beat: false,
                 buy: false,
                 buy_first_card: true,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: nil,
                 round_match_player: match_player
               })
    end

    test "returns the serialized match player when it is my time" do
      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "10", "suit" => "hearts", "deck" => 1},
            %{"value" => "J", "suit" => "hearts", "deck" => 1},
            %{"value" => "Q", "suit" => "hearts", "deck" => 1}
          ]
        )

      match_event = insert(:match_event, match_player: match_player, type: "BUY")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: true,
                 answer_first_card: false,
                 ask_beat: true,
                 beat: false,
                 buy: false,
                 buy_first_card: false,
                 discard: true,
                 drop_collection: true,
                 false_beat: false,
                 replace_joker: true,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event,
                 round_match_player: match_player
               })
    end

    test "returns the serialized match player when it is the not my time and the previous event is DISCARD" do
      match_player1 =
        insert(:match_player,
          false_beat: false,
          hand: [
            %{"value" => "10", "suit" => "hearts", "deck" => 1},
            %{"value" => "J", "suit" => "hearts", "deck" => 1}
          ]
        )

      match_player2 = insert(:match_player)
      match_event = insert(:match_event, match_player: match_player1, type: "DISCARD")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: true,
                 beat: false,
                 buy: false,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player1,
                 previous_event: match_event,
                 round_match_player: match_player2
               })
    end

    test "returns the serialized match player when it is the not my time, the previous event is DISCARD but match player has only one card" do
      match_player1 =
        insert(:match_player,
          false_beat: false,
          hand: [%{"value" => "10", "suit" => "hearts", "deck" => 1}]
        )

      match_player2 = insert(:match_player)
      match_event = insert(:match_event, match_player: match_player1, type: "DISCARD")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: false,
                 beat: false,
                 buy: false,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player1,
                 previous_event: match_event,
                 round_match_player: match_player2
               })
    end

    test "returns the serialized match player when it is the not my time and false beat" do
      match_player1 = insert(:match_player, false_beat: true)
      match_player2 = insert(:match_player)
      match_event = insert(:match_event, match_player: match_player1, type: "DISCARD")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: false,
                 beat: false,
                 buy: false,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player1,
                 previous_event: match_event,
                 round_match_player: match_player2
               })
    end

    test "returns the serialized match player when it is the not my time and the previous event is not DISCARD" do
      match_player1 = insert(:match_player, false_beat: false)
      match_player2 = insert(:match_player)
      match_event = insert(:match_event, match_player: match_player1, type: "BUY")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: false,
                 beat: false,
                 buy: false,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player1,
                 previous_event: match_event,
                 round_match_player: match_player2
               })
    end

    test "returns the serialized match player when it asked beat" do
      match_player = insert(:match_player, asked_beat: true, false_beat: false)
      match_event = insert(:match_event, type: "DISCARD")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: true,
                 answer_first_card: false,
                 ask_beat: false,
                 beat: false,
                 buy: true,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: true,
                 false_beat: false,
                 replace_joker: true,
                 take_discard_pile: true
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event,
                 round_match_player: match_player
               })
    end

    test "returns the serialized match player when it taked the first card" do
      match_player = insert(:match_player)
      match_event = insert(:match_event, match_player: match_player, type: "BUY_FIRST_CARD")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: true,
                 ask_beat: false,
                 beat: false,
                 buy: false,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event,
                 round_match_player: match_player
               })
    end

    test "returns a serialized match match when match player rejects the first card" do
      match_player = insert(:match_player)
      match_event = insert(:match_event, match_player: match_player, type: "REJECT_FIRST_CARD")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: false,
                 beat: false,
                 buy: true,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event,
                 round_match_player: match_player
               })
    end

    test "returns a serialized match player when its hand is empty" do
      match_player = insert(:match_player, hand: [])

      match_event =
        insert(:match_event, match_player: match_player, type: "ADD_CARD_TO_COLLECTION")

      assert %{
               match_player_id: _,
               match_player_hand: _,
               taked_card: nil,
               abilities: %{
                 add_card_to_collection: false,
                 answer_first_card: false,
                 ask_beat: true,
                 beat: true,
                 buy: false,
                 buy_first_card: false,
                 discard: false,
                 drop_collection: false,
                 false_beat: false,
                 replace_joker: false,
                 take_discard_pile: false
               }
             } =
               MatchPlayerSerializer.serialize(%{
                 match_player: match_player,
                 previous_event: match_event,
                 round_match_player: match_player
               })
    end

    # test "returns a serialized match player with previous_event's type equals to ASK_BEAT" do
    #   match_player = build(:match_player)
    #   match_event = build(:match_event, type: "ASK_BEAT")

    #   assert %{
    #            match_player_id: _,
    #            match_player_hand: match_player_hand,
    #            asked_beat: true,
    #            bought_first_card: false,
    #            taked_discard_pile: false,
    #            taked_card: nil
    #          } =
    #            MatchPlayerSerializer.serialize(%{
    #              match_player: match_player,
    #              previous_event: match_event,
    #              round_match_player_id: round_match_player_id
    #            })

    #   assert is_list(match_player_hand)
    #   assert length(match_player_hand) == 9
    # end

    # test "returns a serialized match player with previous_event's type equals to BUY_FIRST_CARD" do
    #   match_player = build(:match_player)

    #   match_event =
    #     build(:match_event,
    #       type: "BUY_FIRST_CARD",
    #       taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    #     )

    #   assert %{
    #            match_player_id: _,
    #            match_player_hand: match_player_hand,
    #            asked_beat: false,
    #            bought_first_card: true,
    #            taked_discard_pile: false,
    #            taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    #          } =
    #            MatchPlayerSerializer.serialize(%{
    #              match_player: match_player,
    #              previous_event: match_event
    #            })

    #   assert is_list(match_player_hand)
    #   assert length(match_player_hand) == 9
    # end

    # test "returns a serialized match player with previous_event's type equals to TAKE_DISCARD_PILE" do
    #   match_player = build(:match_player)

    #   match_event =
    #     build(:match_event,
    #       type: "TAKE_DISCARD_PILE",
    #       taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    #     )

    #   assert %{
    #            match_player_id: _,
    #            match_player_hand: match_player_hand,
    #            asked_beat: false,
    #            bought_first_card: false,
    #            taked_discard_pile: true,
    #            taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    #          } =
    #            MatchPlayerSerializer.serialize(%{
    #              match_player: match_player,
    #              previous_event: match_event
    #            })

    #   assert is_list(match_player_hand)
    #   assert length(match_player_hand) == 9
    # end

    # test "returns a serialized match player without previous_event" do
    #   match_player = build(:match_player)

    #   assert %{
    #            match_player_id: _,
    #            match_player_hand: match_player_hand,
    #            asked_beat: false,
    #            bought_first_card: false,
    #            taked_discard_pile: false,
    #            taked_card: nil
    #          } =
    #            MatchPlayerSerializer.serialize(%{
    #              match_player: match_player,
    #              previous_event: nil
    #            })

    #   assert is_list(match_player_hand)
    #   assert length(match_player_hand) == 9
    # end
  end
end
