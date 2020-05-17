defmodule Pontinho.LoadMatchTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.LoadMatch

  test "returns the match and the round match player when match has no events" do
    croupier = insert(:player)
    match = insert(:match, croupier: croupier)
    insert(:match_player, match: match, player: croupier)
    [match_player | _tail] = insert_list(3, :match_player, match: match)

    assert %{match: returned_match, round_match_player: round_match_player} =
             LoadMatch.run(match.id)

    assert returned_match.id == match.id
    assert Ecto.assoc_loaded?(returned_match.match_collections)
    assert Ecto.assoc_loaded?(returned_match.match_players)

    match_players_sequence = Enum.map(returned_match.match_players, & &1.player.sequence)
    assert match_players_sequence == Enum.sort(match_players_sequence)

    assert round_match_player.id == match_player.id
  end

  test "returns the match and the round match player when match has events" do
    match = insert(:match)
    [first_match_player, second_match_player, _] = insert_list(3, :match_player, match: match)
    insert(:match_event, match: match, match_player: first_match_player)

    assert %{match: returned_match, round_match_player: round_match_player} =
             LoadMatch.run(match.id)

    assert returned_match.id == match.id
    assert Ecto.assoc_loaded?(returned_match.match_collections)
    assert Ecto.assoc_loaded?(returned_match.match_players)

    match_players_sequence = Enum.map(returned_match.match_players, & &1.player.sequence)
    assert match_players_sequence == Enum.sort(match_players_sequence)

    assert round_match_player.id == second_match_player.id
  end

  test "returns the match and the round match player when it is the croupier time" do
    croupier = insert(:player)
    match = insert(:match, croupier: croupier)
    first_match_player = insert(:match_player, match: match, player: croupier)
    second_match_player = insert(:match_player, match: match)
    insert(:match_event, match: match, match_player: second_match_player)

    assert %{match: returned_match, round_match_player: round_match_player} =
             LoadMatch.run(match.id)

    assert returned_match.id == match.id
    assert Ecto.assoc_loaded?(returned_match.match_collections)
    assert Ecto.assoc_loaded?(returned_match.match_players)

    match_players_sequence = Enum.map(returned_match.match_players, & &1.player.sequence)
    assert match_players_sequence == Enum.sort(match_players_sequence)

    assert round_match_player.id == first_match_player.id
  end
end
