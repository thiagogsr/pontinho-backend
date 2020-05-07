defmodule PontinhoWeb.JoinGameControllerTest do
  use PontinhoWeb.ConnCase, async: true

  import Pontinho.Factory

  describe "POST create" do
    test "returns 200 when params are valid", %{conn: conn} do
      %{id: game_id} = insert(:game, betting_table: [50, 100, 200, 400, 800, 1600])

      conn =
        post(conn, "/api/v1/games/#{game_id}/join", %{
          "name" => "New Player"
        })

      assert %{
               "game_id" => ^game_id,
               "betting_table" => [50, 100, 200, 400, 800, 1600],
               "player" => %{"id" => _, "name" => "New Player", "points" => 99},
               "matches" => []
             } = json_response(conn, 200)
    end

    test "returns 422 when player name is missing", %{conn: conn} do
      game = insert(:game)

      conn =
        post(conn, "/api/v1/games/#{game.id}/join", %{
          "name" => ""
        })

      assert %{"errors" => [%{"name" => "can't be blank"}]} = json_response(conn, 422)
    end

    test "returns 400 when game is already started", %{conn: conn} do
      game = insert(:game)
      insert(:match, game: game)

      conn =
        post(conn, "/api/v1/games/#{game.id}/join", %{
          "name" => "Player name"
        })

      assert %{"error" => "game already started"} = json_response(conn, 422)
    end
  end
end
