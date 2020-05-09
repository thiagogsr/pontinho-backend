defmodule PontinhoWeb.MatchController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.{Endpoint, MatchSerializer}

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, match} <- Pontinho.start_match(game) do
      match_player = Pontinho.find_match_player(match, params["player_id"])
      serialized_match = MatchSerializer.serialize(match, match_player)
      Endpoint.broadcast("game:#{game.id}", "match_started", serialized_match)

      conn
      |> put_status(:created)
      |> json(%{status: "started"})
    end
  end
end
