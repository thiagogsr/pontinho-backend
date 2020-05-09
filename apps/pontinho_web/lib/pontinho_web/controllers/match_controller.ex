defmodule PontinhoWeb.MatchController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.{Endpoint, MatchSerializer}

  action_fallback PontinhoWeb.FallbackController

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, match} <- Pontinho.start_match(game) do
      serialized_match = MatchSerializer.serialize(match)
      Endpoint.broadcast("game:#{game.id}", "match_started", serialized_match)

      conn
      |> put_status(:created)
      |> json(%{status: "started"})
    end
  end
end
