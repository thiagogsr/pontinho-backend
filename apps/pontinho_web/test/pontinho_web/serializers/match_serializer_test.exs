defmodule PontinhoWeb.MatchSerializerTest do
  use ExUnit.Case, async: true

  import Pontinho.Factory

  alias PontinhoWeb.MatchSerializer

  describe "serialize/2" do
    test "returns a serialized match with stock" do
      match_players = build_list(5, :match_player)
      match_collections = build_list(2, :match_collection)

      match =
        build(:match,
          match_players: match_players,
          match_collections: match_collections,
          stock: [%{"suit" => "clubs", "value" => "A", "deck" => 2}],
          discard_pile: [%{"suit" => "suits", "value" => "J", "deck" => 2}],
          pre_joker: %{"suit" => "hearts", "value" => "10", "deck" => 1}
        )

      assert %{
               match_id: _,
               pre_joker: %{"suit" => "hearts", "value" => "10", "deck" => 1},
               no_stock: false,
               head_discard_pile: %{"suit" => "suits", "value" => "J", "deck" => 2},
               match_collections: serialized_match_collections,
               match_players: serialized_match_players
             } = MatchSerializer.serialize(match)

      assert is_list(serialized_match_collections)
      assert length(serialized_match_collections) == 2

      assert is_list(serialized_match_players)
      assert length(serialized_match_players) == 5
    end

    test "returns a serialized match without stock" do
      match_players = build_list(5, :match_player)
      match_collections = build_list(2, :match_collection)

      match =
        build(:match,
          match_players: match_players,
          match_collections: match_collections,
          stock: [],
          discard_pile: [%{"suit" => "suits", "value" => "J", "deck" => 2}],
          pre_joker: %{"suit" => "hearts", "value" => "10", "deck" => 1}
        )

      assert %{
               match_id: _,
               pre_joker: %{"suit" => "hearts", "value" => "10", "deck" => 1},
               no_stock: true,
               head_discard_pile: %{"suit" => "suits", "value" => "J", "deck" => 2},
               match_collections: serialized_match_collections,
               match_players: serialized_match_players
             } = MatchSerializer.serialize(match)

      assert is_list(serialized_match_collections)
      assert length(serialized_match_collections) == 2

      assert is_list(serialized_match_players)
      assert length(serialized_match_players) == 5
    end
  end
end
