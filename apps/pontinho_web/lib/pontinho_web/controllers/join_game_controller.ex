defmodule PontinhoWeb.JoinGameController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.{Endpoint, GameView}

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, player} <- Pontinho.join_game(game, params["name"]) do
      players = Pontinho.list_players(game)
      matches = Pontinho.list_game_matches(game)
      Endpoint.broadcast("game:#{game.id}", "player_joined", %{players: players_json(players)})

      conn
      |> put_view(GameView)
      |> render("game.json", %{game: game, player: player, players: players, matches: matches})
    end
  end

  defp players_json(players) do
    Enum.map(players, fn player ->
      %{
        id: player.id,
        name: player.name,
        points: player.points
      }
    end)
  end
end
