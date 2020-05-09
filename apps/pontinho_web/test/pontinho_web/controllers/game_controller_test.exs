defmodule PontinhoWeb.GameControllerTest do
  use PontinhoWeb.ConnCase, async: true

  import Pontinho.Factory

  describe "POST create" do
    test "returns 200 when params are valid", %{conn: conn} do
      conn =
        post(conn, "/api/v1/games", %{
          "betting_table" => [50, 100, 200, 400, 800, 1600],
          "name" => "Player 1"
        })

      assert %{
               "game_id" => _,
               "betting_table" => [50, 100, 200, 400, 800, 1600],
               "player_id" => _,
               "players" => [%{"id" => _, "name" => "Player 1", "points" => 99}],
               "matches" => []
             } = json_response(conn, 200)
    end

    test "returns 422 when betting player is missing", %{conn: conn} do
      conn =
        post(conn, "/api/v1/games", %{
          "betting_table" => [],
          "name" => "Player 1"
        })

      assert %{"errors" => ["betting_table should have at least 5 item(s)"]} =
               json_response(conn, 422)
    end

    test "returns 422 when player name is missing", %{conn: conn} do
      conn =
        post(conn, "/api/v1/games", %{
          "betting_table" => [50, 100, 200, 400, 800, 1600],
          "name" => ""
        })

      assert %{"errors" => ["name can't be blank"]} = json_response(conn, 422)
    end
  end

  describe "GET show" do
    test "returns 200 when game is found", %{conn: conn} do
      game = insert(:game)
      insert_list(5, :player, game: game)
      insert_list(3, :match, game: game)

      conn = get(conn, "/api/v1/games/#{game.id}")

      assert %{
               "game_id" => _,
               "betting_table" => [0, 50, 100, 200, 400, 800],
               "players" => players,
               "matches" => matches
             } = json_response(conn, 200)

      assert is_list(players)
      assert length(players) == 5

      assert is_list(matches)
      assert length(matches) == 3
    end
  end
end
