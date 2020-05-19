defmodule Pontinho.FinishMatchTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{FinishMatch, Match, MatchPlayer, Player}

  test "updates the match winner and calculate points for match players" do
    game = insert(:game)
    match = insert(:match, game: game)
    winner = insert(:match_player, match: match, hand: [], player: build(:player, game: game))

    Enum.each(0..3, fn _ ->
      insert(:match_player,
        match: match,
        player: build(:player, game: game),
        hand: [%{"value" => "10", "suit" => "diamonds"}, %{"value" => "A", "suit" => "diamonds"}]
      )
    end)

    assert {:ok, %Match{} = match} = FinishMatch.run(match, winner)

    assert %MatchPlayer{points: 0, broke: nil, player: %Player{broke_times: 0, points: 99}} =
             match.winner

    assert Enum.count(
             match.match_players,
             &(is_nil(&1.broke) &&
                 &1.points == 25 &&
                 &1.player.broke_times == 0 &&
                 &1.player.points == 74)
           ) == 4

    assert is_nil(match.game.winner_id)
  end

  test "updates the player broke times when match player points is greater than player points" do
    game = insert(:game)
    match = insert(:match, game: game, joker: %{"value" => "10", "suit" => "diamonds"})

    winner =
      insert(:match_player,
        match: match,
        hand: [],
        player: build(:player, broke_times: 2, game: game)
      )

    insert(:match_player,
      match: match,
      player: build(:player, broke_times: 3, game: game),
      hand: [
        %{"value" => "A", "suit" => "diamonds"},
        %{"value" => "A", "suit" => "diamonds"},
        %{"value" => "A", "suit" => "clubs"},
        %{"value" => "A", "suit" => "clubs"},
        %{"value" => "10", "suit" => "diamonds"},
        %{"value" => "K", "suit" => "hearts"},
        %{"value" => "Q", "suit" => "hearts"}
      ]
    )

    Enum.each(0..2, fn _ ->
      insert(:match_player,
        match: match,
        player: build(:player, broke_times: 1, game: game),
        hand: [%{"value" => "10", "suit" => "diamonds"}, %{"value" => "A", "suit" => "diamonds"}]
      )
    end)

    assert {:ok, %Match{} = match} = FinishMatch.run(match, winner)

    assert %MatchPlayer{points: 0, broke: nil, player: %Player{broke_times: 2, points: 99}} =
             match.winner

    assert Enum.count(
             match.match_players,
             &(is_nil(&1.broke) &&
                 &1.points == 35 &&
                 &1.player.broke_times == 1 &&
                 &1.player.points == 64)
           ) == 3

    assert Enum.count(
             match.match_players,
             &(&1.broke == 4 &&
                 &1.points == 100 &&
                 &1.player.broke_times == 4 &&
                 &1.player.points == 64)
           ) == 1

    assert is_nil(match.game.winner_id)
  end

  test "finishes the match and the game" do
    game = insert(:game)
    match = insert(:match, game: game, joker: %{"value" => "10", "suit" => "diamonds"})

    winner =
      insert(:match_player,
        match: match,
        hand: [],
        player: build(:player, broke_times: 2, game: game)
      )

    Enum.each(0..3, fn _ ->
      insert(:match_player,
        match: match,
        player: build(:player, broke_times: 3, game: game),
        hand: [
          %{"value" => "A", "suit" => "diamonds"},
          %{"value" => "A", "suit" => "diamonds"},
          %{"value" => "A", "suit" => "clubs"},
          %{"value" => "A", "suit" => "clubs"},
          %{"value" => "10", "suit" => "diamonds"},
          %{"value" => "K", "suit" => "hearts"},
          %{"value" => "Q", "suit" => "hearts"}
        ]
      )
    end)

    assert {:ok, %Match{} = match} = FinishMatch.run(match, winner)

    assert %MatchPlayer{points: 0, broke: nil, player: %Player{broke_times: 2, points: 99}} =
             match.winner

    assert Enum.count(
             match.match_players,
             &(&1.broke == 4 &&
                 &1.points == 100 &&
                 &1.player.broke_times == 4 &&
                 &1.player.points == 99 &&
                 &1.player.balance == -400)
           ) == 4

    assert %Player{broke_times: 2, points: 99, balance: 1600} = match.game.winner
  end
end
