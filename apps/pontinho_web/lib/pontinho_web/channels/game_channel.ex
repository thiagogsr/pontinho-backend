defmodule PontinhoWeb.GameChannel do
  @moduledoc """
  Game channel
  """

  use PontinhoWeb, :channel

  intercept ["match_started"]

  def join("game:" <> game_id, _, %{assigns: %{player: player}} = socket) do
    if player.game_id == game_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_out("match_started", msg, %{assigns: %{player: player}} = socket) do
    %{match_id: match_id} = msg

    case Pontinho.find_match_player(match_id, player.id) do
      nil ->
        {:noreply, socket}

      match_player ->
        new_attributes = %{match_player_id: match_player.id, match_player_hand: match_player.hand}
        new_msg = Map.merge(msg, new_attributes)
        push(socket, "match_started", new_msg)

        {:noreply, socket}
    end
  end
end
