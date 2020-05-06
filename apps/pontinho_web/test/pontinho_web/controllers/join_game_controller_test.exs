defmodule PontinhoWeb.JoinGameControllerTest do
  use PontinhoWeb.ConnCase, async: true

  import Pontinho.Factory

  describe "POST create" do
    test "returns 200 when params are valid", %{conn: conn} do
      %{id: game_id} = game = insert(:game, betting_table: [50, 100, 200, 400, 800, 1600])
      insert_list(2, :player, game: game)

      conn =
        post(conn, "/api/v1/games/#{game_id}/join", %{
          "name" => "New Player"
        })

      assert %{
               "game_id" => ^game_id,
               "betting_table" => [50, 100, 200, 400, 800, 1600],
               "player" => %{"id" => _, "name" => "New Player", "points" => 99},
               "players" => players
             } = json_response(conn, 200)

      assert is_list(players)
      assert length(players) == 3
    end

    test "returns 422 when player name is missing", %{conn: conn} do
      game = insert(:game)

      conn =
        post(conn, "/api/v1/games/#{game.id}/join", %{
          "name" => ""
        })

      assert %{"errors" => [%{"name" => "can't be blank"}]} = json_response(conn, 422)
    end
  end
end
