defmodule PontinhoWeb.GameController do
  use PontinhoWeb, :controller

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    with {:ok, game} <- Pontinho.create_game(params["betting_table"]),
         {:ok, player} <- Pontinho.join_game(game, params["name"]) do
      render(conn, "game.json", %{game: game, player: player, players: [player], matches: []})
    end
  end
end
