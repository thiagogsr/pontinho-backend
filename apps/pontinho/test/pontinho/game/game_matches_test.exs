defmodule Pontinho.GameMatchesTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.GameMatches

  test "returns a list of matches with ordered match players and croupier" do
    game = insert(:game)

    croupier1 = insert(:player, game: game)
    match1 = insert(:match, game: game, croupier: croupier1)
    mp1 = insert(:match_player, match: match1, player: build(:player, game: game, sequence: 3))
    mp2 = insert(:match_player, match: match1, player: build(:player, game: game, sequence: 2))
    mp3 = insert(:match_player, match: match1, player: build(:player, game: game, sequence: 4))
    mp4 = insert(:match_player, match: match1, player: build(:player, game: game, sequence: 1))

    match2 = insert(:match, game: game)

    [first_match, second_match] = GameMatches.list(game)
    assert first_match.id == match1.id
    assert first_match.croupier.id == croupier1.id
    assert Enum.map(first_match.match_players, & &1.id) == [mp4.id, mp2.id, mp1.id, mp3.id]
    assert Enum.all?(first_match.match_players, &Ecto.assoc_loaded?(&1.player))

    assert second_match.id == match2.id
  end
end
