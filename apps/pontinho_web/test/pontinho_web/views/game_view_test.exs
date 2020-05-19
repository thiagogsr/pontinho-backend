defmodule PontinhoWeb.GameViewTest do
  use ExUnit.Case, async: true

  import Pontinho.Factory

  alias PontinhoWeb.GameView

  test "returns the game and the player" do
    game = build(:game, betting_table: [10, 10, 10, 10, 10])
    player = build(:player, name: "Player", points: 99)

    assert %{
             game_id: nil,
             betting_table: [10, 10, 10, 10, 10],
             player_id: nil,
             players: [%{id: nil, name: "Player", points: 99}],
             matches: []
           } =
             GameView.render("game.json", %{
               game: game,
               player: player,
               players: [player],
               matches: []
             })
  end

  test "returns the game with a unfinished match" do
    game = build(:game, betting_table: [10, 10, 10, 10, 10])
    player = build(:player, name: "Player", points: 99)
    match_player = build(:match_player, player: player, points_before: 99, points: nil)
    match = build(:match, match_players: [match_player], croupier: player)

    assert %{
             game_id: nil,
             betting_table: [10, 10, 10, 10, 10],
             players: [%{id: nil, name: "Player", points: 99}],
             matches: [
               %{
                 id: nil,
                 croupier: "Player",
                 match_players: [
                   %{
                     id: nil,
                     name: "Player",
                     broke: nil,
                     points_before: 99,
                     points: "-"
                   }
                 ]
               }
             ]
           } =
             GameView.render("game.json", %{
               game: game,
               players: [player],
               matches: [match]
             })
  end

  test "returns the game with a finished match" do
    game = build(:game, betting_table: [10, 10, 10, 10, 10])
    player = build(:player, name: "Player", points: 79)
    match_player = build(:match_player, player: player, points_before: 10, points: 20, broke: 1)
    match = build(:match, match_players: [match_player], croupier: player)

    assert %{
             game_id: nil,
             betting_table: [10, 10, 10, 10, 10],
             players: [%{id: nil, name: "Player", points: 79}],
             matches: [
               %{
                 id: nil,
                 croupier: "Player",
                 match_players: [
                   %{
                     id: nil,
                     name: "Player",
                     broke: 1,
                     points_before: 10,
                     points: 20
                   }
                 ]
               }
             ]
           } =
             GameView.render("game.json", %{
               game: game,
               players: [player],
               matches: [match]
             })
  end
end
