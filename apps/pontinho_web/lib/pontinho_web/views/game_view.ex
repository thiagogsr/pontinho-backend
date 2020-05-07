defmodule PontinhoWeb.GameView do
  use PontinhoWeb, :view

  def render("game.json", %{game: game, player: player, matches: matches}) do
    %{
      game_id: game.id,
      betting_table: game.betting_table,
      player: player_json(player),
      matches: Enum.map(matches, &match_json/1)
    }
  end

  defp player_json(player) do
    %{
      id: player.id,
      name: player.name,
      points: player.points
    }
  end

  defp match_json(match) do
    %{
      croupier: match.croupier.name,
      match_players:
        Enum.map(match.match_players, fn match_player ->
          %{
            name: match_player.player.name,
            points_before: match_player.points_before,
            points: match_player.points,
            points_after: match_player.points_before - match_player.points
          }
        end)
    }
  end
end
