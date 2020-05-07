defmodule PontinhoWeb.GameControllerTest do
  use PontinhoWeb.ConnCase, async: true

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
               "player" => %{"id" => _, "name" => "Player 1", "points" => 99},
               "matches" => []
             } = json_response(conn, 200)
    end

    test "returns 422 when betting player is missing", %{conn: conn} do
      conn =
        post(conn, "/api/v1/games", %{
          "betting_table" => [],
          "name" => "Player 1"
        })

      assert %{"errors" => [%{"betting_table" => "should have at least 5 item(s)"}]} =
               json_response(conn, 422)
    end

    test "returns 422 when player name is missing", %{conn: conn} do
      conn =
        post(conn, "/api/v1/games", %{
          "betting_table" => [50, 100, 200, 400, 800, 1600],
          "name" => ""
        })

      assert %{"errors" => [%{"name" => "can't be blank"}]} = json_response(conn, 422)
    end
  end
end
