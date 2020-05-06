defmodule PontinhoWeb.JoinGameController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.GameView

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, player} <- Pontinho.join_game(game, params["name"]) do
      players = Pontinho.list_players(game)

      conn
      |> put_view(GameView)
      |> render("game.json", %{game: game, player: player, players: players})
    end
  end
end
