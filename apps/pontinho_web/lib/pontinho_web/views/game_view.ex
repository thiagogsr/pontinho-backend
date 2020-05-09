defmodule PontinhoWeb.GameView do
  use PontinhoWeb, :view

  def render("game.json", %{game: game, player: player, players: players, matches: matches}) do
    %{
      game_id: game.id,
      betting_table: game.betting_table,
      player_id: player.id,
      players: Enum.map(players, &player_json/1),
      matches: Enum.map(matches, &match_json/1)
    }
  end

  def render("game.json", %{game: game, players: players, matches: matches}) do
    %{
      game_id: game.id,
      betting_table: game.betting_table,
      players: Enum.map(players, &player_json/1),
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
      id: match.id,
      croupier: match.croupier.name,
      match_players:
        Enum.map(match.match_players, fn match_player ->
          %{
            id: match_player.id,
            name: match_player.player.name,
            points_before: match_player.points_before,
            points: cast_points(match_player.points),
            points_after: calculate_match_points(match_player.points_before, match_player.points)
          }
        end)
    }
  end

  defp cast_points(points) when is_nil(points), do: "-"
  defp cast_points(points), do: points

  defp calculate_match_points(_points_before, points) when is_nil(points), do: "-"
  defp calculate_match_points(points_before, points), do: points_before - points
end
