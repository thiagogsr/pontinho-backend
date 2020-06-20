defmodule PontinhoWeb.JoinGameController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.{Endpoint, GameView, PlayerSerializer}

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, player} <- Pontinho.join_game(game, params["name"]) do
      players = Pontinho.list_players(game)
      matches = Pontinho.list_game_matches(game)

      Endpoint.broadcast("game:#{game.id}", "player_joined", %{
        players: Enum.map(players, &PlayerSerializer.serialize/1)
      })

      conn
      |> put_view(GameView)
      |> render("game.json", %{game: game, player: player, players: players, matches: matches})
    end
  end
end
