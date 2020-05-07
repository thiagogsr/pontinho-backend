defmodule PontinhoWeb.JoinGameController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.GameView

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, player} <- Pontinho.join_game(game, params["name"]) do
      matches = Pontinho.list_game_matches(game)

      conn
      |> put_view(GameView)
      |> render("game.json", %{game: game, player: player, matches: matches})
    end
  end
end
