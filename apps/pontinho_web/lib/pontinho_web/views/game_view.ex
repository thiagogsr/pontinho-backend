defmodule PontinhoWeb.GameView do
  use PontinhoWeb, :view

  def render("game.json", %{game: game, player: player}) do
    %{
      game_id: game.id,
      betting_table: game.betting_table,
      player: player_json(player)
    }
  end

  defp player_json(player) do
    %{
      id: player.id,
      name: player.name,
      points: player.points
    }
  end
end