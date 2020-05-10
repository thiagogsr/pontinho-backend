defmodule PontinhoWeb.MatchController do
  use PontinhoWeb, :controller

  alias PontinhoWeb.{Endpoint, MatchPlayerSerializer, MatchSerializer}

  action_fallback PontinhoWeb.FallbackController

  def show(conn, params) do
    match =
      params["match_id"]
      |> Pontinho.load_match()
      |> MatchSerializer.serialize()

    match_player =
      params["match_player_id"]
      |> Pontinho.get_match_player!()
      |> MatchPlayerSerializer.serialize()

    json(conn, %{match: match, match_player: match_player})
  end

  def create(conn, params) do
    game = Pontinho.get_game!(params["game_id"])

    with {:ok, %{id: match_id}} <- Pontinho.start_match(game) do
      serialized_match =
        match_id
        |> Pontinho.load_match()
        |> MatchSerializer.serialize()

      Endpoint.broadcast("game:#{game.id}", "match_started", %{match: serialized_match})

      conn
      |> put_status(:created)
      |> json(%{status: "started"})
    end
  end
end
