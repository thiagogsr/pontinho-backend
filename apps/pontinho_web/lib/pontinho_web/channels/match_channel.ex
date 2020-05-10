defmodule PontinhoWeb.MatchChannel do
  @moduledoc """
  Match channel
  """

  use PontinhoWeb, :channel

  def join("match:" <> match_id, _, %{assigns: %{player: player}} = socket) do
    case Pontinho.find_match_player(match_id, player.id) do
      nil ->
        {:error, %{reason: "unauthorized"}}

      _match_player ->
        {:ok, socket}
    end
  end
end
