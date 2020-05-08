defmodule PontinhoWeb.JoinGameControllerTest do
  use PontinhoWeb.ConnCase, async: true
  use Phoenix.ChannelTest

  import Pontinho.Factory

  alias PontinhoWeb.{GameChannel, PlayerSocket}

  describe "POST create" do
    test "returns 200 when params are valid", %{conn: conn} do
      %{id: game_id} = game = insert(:game, betting_table: [50, 100, 200, 400, 800, 1600])
      player = insert(:player, name: "Player 1", game: game)

      {:ok, _, _} =
        PlayerSocket
        |> socket("player", %{player: player})
        |> subscribe_and_join(GameChannel, "game:#{game_id}")

      conn =
        post(conn, "/api/v1/games/#{game_id}/join", %{
          "name" => "New Player"
        })

      assert %{
               "game_id" => ^game_id,
               "betting_table" => [50, 100, 200, 400, 800, 1600],
               "player" => %{"id" => _, "name" => "New Player", "points" => 99},
               "players" => [
                 %{"id" => _, "name" => "Player 1", "points" => 99},
                 %{"id" => _, "name" => "New Player", "points" => 99}
               ],
               "matches" => []
             } = json_response(conn, 200)

      assert_broadcast "player_joined", %{
        players: [
          %{id: _, name: "Player 1", points: 99},
          %{id: _, name: "New Player", points: 99}
        ]
      }
    end

    test "returns 422 when player name is missing", %{conn: conn} do
      game = insert(:game)

      conn =
        post(conn, "/api/v1/games/#{game.id}/join", %{
          "name" => ""
        })

      assert %{"errors" => ["name can't be blank"]} = json_response(conn, 422)
    end

    test "returns 400 when game is already started", %{conn: conn} do
      game = insert(:game)
      insert(:match, game: game)

      conn =
        post(conn, "/api/v1/games/#{game.id}/join", %{
          "name" => "Player name"
        })

      assert %{"errors" => ["game already started"]} = json_response(conn, 422)
    end
  end
end
