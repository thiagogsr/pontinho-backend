defmodule PontinhoWeb.MatchControllerTest do
  use PontinhoWeb.ConnCase, async: true
  use Phoenix.ChannelTest

  import Pontinho.Factory

  alias PontinhoWeb.{GameChannel, PlayerSocket}

  describe "POST create" do
    test "returns 201 when params are valid", %{conn: conn} do
      game = insert(:game)
      [player | _tail] = insert_list(3, :player, game: game)

      {:ok, _, _} =
        PlayerSocket
        |> socket("player", %{player: player})
        |> subscribe_and_join(GameChannel, "game:#{game.id}")

      conn =
        post(conn, "/api/v1/matches", %{
          "game_id" => game.id,
          "player_id" => player.id
        })

      assert %{"status" => "started"} = json_response(conn, 201)

      assert_broadcast "match_started", %{
        match_id: _,
        match_player_id: _,
        match_player_hand: _,
        pre_joker: _,
        no_stock: _,
        head_discard_pile: _,
        match_collections: _,
        match_players: _
      }
    end

    test "returns 422 when there is one player", %{conn: conn} do
      game = insert(:game)
      player = insert(:player, game: game)

      conn =
        post(conn, "/api/v1/matches", %{
          "game_id" => game.id,
          "player_id" => player.id
        })

      assert %{"errors" => ["match_players should have at least 2 item(s)"]} =
               json_response(conn, 422)
    end

    test "returns 422 when there are more than 9 players", %{conn: conn} do
      game = insert(:game)
      [player | _] = insert_list(10, :player, game: game)

      conn =
        post(conn, "/api/v1/matches", %{
          "game_id" => game.id,
          "player_id" => player.id
        })

      assert %{"errors" => ["match_players should have at most 9 item(s)"]} =
               json_response(conn, 422)
    end
  end
end
