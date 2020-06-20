defmodule PontinhoWeb.GameViewTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias PontinhoWeb.GameView

  test "returns the game and the player" do
    game = build(:game, betting_table: [10, 10, 10, 10, 10])
    player = build(:player, name: "Player", points: 99, host: true)

    assert %{
             game_id: nil,
             betting_table: [10, 10, 10, 10, 10],
             player_id: nil,
             players: [%{id: nil, name: "Player", points: 99, balance: nil, host: true}],
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
    player = build(:player, name: "Player", points: 99, host: true)
    match_player = build(:match_player, player: player, points_before: 99, points: nil)
    match = build(:match, match_players: [match_player], croupier: player)

    assert %{
             game_id: nil,
             betting_table: [10, 10, 10, 10, 10],
             winner_id: nil,
             players: [%{id: nil, name: "Player", points: 99, balance: nil, host: true}],
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
    player = build(:player, name: "Player", points: 79, host: true)
    match_player = build(:match_player, player: player, points_before: 10, points: 20, broke: 1)
    match = build(:match, match_players: [match_player], croupier: player)

    assert %{
             game_id: nil,
             betting_table: [10, 10, 10, 10, 10],
             winner_id: nil,
             players: [%{id: nil, name: "Player", points: 79, balance: nil, host: true}],
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

  test "returns a finished game" do
    player = insert(:player, name: "Player", points: 79, balance: 100, host: true)
    game = insert(:game, betting_table: [10, 10, 10, 10, 10], winner: player)
    match_player = insert(:match_player, player: player, points_before: 10, points: 20, broke: 1)
    match = insert(:match, match_players: [match_player], croupier: player)

    assert %{
             game_id: game.id,
             betting_table: [10, 10, 10, 10, 10],
             winner_id: player.id,
             players: [
               %{
                 id: player.id,
                 name: "Player",
                 points: 79,
                 playing: true,
                 balance: 100,
                 host: true
               }
             ],
             matches: [
               %{
                 id: match.id,
                 croupier: "Player",
                 match_players: [
                   %{
                     id: match_player.id,
                     name: "Player",
                     broke: 1,
                     points_before: 10,
                     points: 20
                   }
                 ]
               }
             ]
           } ==
             GameView.render("game.json", %{
               game: game,
               players: [player],
               matches: [match]
             })
  end
end
