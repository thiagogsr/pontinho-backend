defmodule Pontinho.FinishMatch do
  @moduledoc """
  Finish match and maybe game
  """

  import Ecto.Changeset

  alias Pontinho.{CalculatePoints, Match, MatchPlayer, Repo}

  @spec run(%Match{}, %MatchPlayer{}) :: {:ok, %Match{}} | {:error, %Ecto.Changeset{}}
  def run(match, winner) do
    with {:ok, match} <-
           match
           |> Repo.preload([:winner, match_players: :player])
           |> change()
           |> put_assoc(:winner, winner)
           |> prepare_changes(&prepare_result/1)
           |> Repo.update() do
      {:ok,
       Repo.preload(match, [winner: :player, match_players: :player, game: :winner], force: true)}
    end
  end

  defp prepare_result(changeset) do
    %{match_players: match_players, joker: joker} = apply_changes(changeset)

    match_players
    |> calculate_match_points(joker)
    |> split_match_players()
    |> calculate_game_points()
    |> maybe_finish_game()

    changeset
  end

  defp calculate_match_points(match_players, joker) do
    Enum.map(match_players, fn %{player: player} = match_player ->
      points = CalculatePoints.run(match_player.hand, joker)
      broke = points > player.points

      match_player
      |> cast(%{points: points, broke: broke}, [:points, :broke])
      |> Repo.update!()
    end)
  end

  defp split_match_players(match_players) do
    Enum.split_with(match_players, & &1.broke)
  end

  defp calculate_game_points({broke_match_players, no_broke_match_players}) do
    players =
      Enum.map(no_broke_match_players, fn %{player: player, points: points} ->
        player
        |> cast(%{points: player.points - points}, [:points])
        |> Repo.update!()
      end)

    %{points: smaller_points} = Enum.min_by(players, & &1.points)

    Enum.each(broke_match_players, fn %{player: player} ->
      broke_times = player.broke_times + 1

      player
      |> cast(%{points: smaller_points, broke_times: broke_times}, [:points, :broke_times])
      |> Repo.update!()
    end)

    {broke_match_players, no_broke_match_players}
  end

  defp maybe_finish_game({_, no_broke_match_players}) when length(no_broke_match_players) == 1 do
    [%{player: winner}] = no_broke_match_players
    %{game: game} = Repo.preload(winner, game: [:winner, :players])

    game
    |> finish_game(winner)
    |> update_losers_balance()
    |> update_winner_balance(winner)
  end

  defp maybe_finish_game({broke_match_players, no_broke_match_players}) do
    {broke_match_players, no_broke_match_players}
  end

  defp finish_game(game, winner) do
    game
    |> change()
    |> put_assoc(:winner, winner)
    |> Repo.update!()
  end

  defp update_losers_balance(game) do
    game.players
    |> Enum.reject(&(&1.id == game.winner_id))
    |> Enum.map(fn player ->
      balance = Enum.at(game.betting_table, player.broke_times) * -1

      player
      |> cast(%{balance: balance}, [:balance])
      |> Repo.update!()
    end)
  end

  defp update_winner_balance(players, winner) do
    balance = Enum.reduce(players, 0, &(&1.balance + &2)) * -1

    winner
    |> cast(%{balance: balance}, [:balance])
    |> Repo.update!()
  end
end
