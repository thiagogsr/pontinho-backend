defmodule PontinhoWeb.GameChannel do
  @moduledoc """
  Game channel
  """

  use PontinhoWeb, :channel

  alias PontinhoWeb.MatchPlayerSerializer

  intercept ["match_started"]

  def join("game:" <> game_id, _, %{assigns: %{player: player}} = socket) do
    if player.game_id == game_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_out("match_started", msg, %{assigns: %{player: player}} = socket) do
    %{match: %{match_id: match_id}} = msg

    case Pontinho.load_match_player(%{match_id: match_id, player_id: player.id}) do
      %{match_player: nil} ->
        {:noreply, socket}

      match_player ->
        serialized_match_player = MatchPlayerSerializer.serialize(match_player)
        new_msg = Map.merge(msg, %{match_player: serialized_match_player})
        push(socket, "match_started", new_msg)

        {:noreply, socket}
    end
  end
end
