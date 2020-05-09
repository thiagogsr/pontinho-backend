defmodule PontinhoWeb.MatchControllerTest do
  use PontinhoWeb.ConnCase, async: true
  use Phoenix.ChannelTest

  import Pontinho.Factory

  alias PontinhoWeb.{GameChannel, PlayerSocket}

  describe "GET show" do
    test "returns 200 with the match and the match player", %{conn: conn} do
      match = insert(:match)
      match_player = insert(:match_player)

      conn = get(conn, "/api/v1/matches/#{match.id}/#{match_player.id}")
      assert %{"match" => _, "match_player" => _} = json_response(conn, 200)
    end
  end

  describe "POST create" do
    test "returns 201 when params are valid", %{conn: conn} do
      game = insert(:game)
      [player | _tail] = insert_list(3, :player, game: game)

      {:ok, _, _} =
        PlayerSocket
        |> socket("player", %{player: player})
        |> subscribe_and_join(GameChannel, "game:#{game.id}")

      conn = post(conn, "/api/v1/matches", %{"game_id" => game.id})

      assert %{"status" => "started"} = json_response(conn, 201)

      assert_push "match_started", %{
        match: %{
          match_id: _,
          pre_joker: _,
          head_stock_deck: _,
          head_discard_pile: _,
          match_collections: _,
          match_players: _
        },
        match_player: %{
          match_player_id: _,
          match_player_hand: _
        }
      }
    end

    test "returns 422 when there is one player", %{conn: conn} do
      game = insert(:game)
      insert(:player, game: game)

      conn = post(conn, "/api/v1/matches", %{"game_id" => game.id})

      assert %{"errors" => ["match_players should have at least 2 item(s)"]} =
               json_response(conn, 422)
    end

    test "returns 422 when there are more than 9 players", %{conn: conn} do
      game = insert(:game)
      insert_list(10, :player, game: game)

      conn = post(conn, "/api/v1/matches", %{"game_id" => game.id})

      assert %{"errors" => ["match_players should have at most 9 item(s)"]} =
               json_response(conn, 422)
    end
  end
end
