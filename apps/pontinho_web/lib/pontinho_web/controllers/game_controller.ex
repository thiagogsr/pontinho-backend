defmodule PontinhoWeb.GameController do
  use PontinhoWeb, :controller

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    with {:ok, game} <- Pontinho.create_game(params["betting_table"]),
         {:ok, player} <- Pontinho.join_game(game, params["name"]) do
      conn
      |> put_status(:created)
      |> render("game.json", %{game: game, player: player, players: [player], matches: []})
    end
  end

  def show(conn, params) do
    game = Pontinho.get_game!(params["id"])
    players = Pontinho.list_players(game)
    matches = Pontinho.list_game_matches(game)

    render(conn, "game.json", %{game: game, players: players, matches: matches})
  end
end
