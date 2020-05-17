defmodule PontinhoWeb.MatchPlayerSerializerTest do
  use ExUnit.Case, async: true

  import Pontinho.Factory

  alias PontinhoWeb.MatchPlayerSerializer

  describe "serialize/1" do
    test "returns a serialized match player" do
      match_player = build(:match_player)

      assert %{
               match_player_id: _,
               match_player_hand: match_player_hand,
               taked_card: nil
             } = MatchPlayerSerializer.serialize(%{match_player: match_player, taked_card: nil})

      assert is_list(match_player_hand)
      assert length(match_player_hand) == 9
    end
  end
end
