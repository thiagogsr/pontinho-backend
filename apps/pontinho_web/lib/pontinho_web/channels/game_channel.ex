defmodule PontinhoWeb.GameChannel do
  @moduledoc """
  Game channel
  """

  use PontinhoWeb, :channel

  def join("game:" <> game_id, _, %{assigns: %{player: player}} = socket) do
    if player.game_id == game_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
