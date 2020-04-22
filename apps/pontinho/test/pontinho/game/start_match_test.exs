defmodule Pontinho.StartMatchTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{Deck, Match, StartMatch}

  test "creates a match" do
    game = insert(:game)
    players_count = 5
    [first_player | _tail] = insert_list(players_count, :player, game: game)

    assert {:ok, %Match{} = match} = StartMatch.run(game)
    assert match.croupier.id == first_player.id
    assert match.game == game
    assert length(match.stock) == 104 - players_count * 9 - 1
    assert match.discard_pile == []
    refute is_nil(match.pre_joker)
    assert match.joker == Deck.next_card(match.pre_joker)
    assert length(match.match_players) == players_count
    assert Enum.all?(match.match_players, fn match_player -> length(match_player.hand) == 9 end)
  end

  test "creates a match to a started game" do
    game = insert(:game)
    players_count = 3
    [first_player, second_player, _third_player] = insert_list(players_count, :player, game: game)
    insert(:match, game: game, croupier: first_player)

    assert {:ok, %Match{} = match} = StartMatch.run(game)
    assert match.croupier.id == second_player.id
    assert match.game == game
    assert length(match.stock) == 104 - players_count * 9 - 1
    assert match.discard_pile == []
    refute is_nil(match.pre_joker)
    assert match.joker == Deck.next_card(match.pre_joker)
    assert length(match.match_players) == players_count
    assert Enum.all?(match.match_players, fn match_player -> length(match_player.hand) == 9 end)
  end

  test "skips not playing players" do
    game = insert(:game)
    first_player = insert(:player, game: game, playing: true, sequence: 1)
    insert(:player, game: game, playing: false, sequence: 2)
    third_player = insert(:player, game: game, playing: true, sequence: 3)
    insert(:match, game: game, croupier: first_player)

    assert {:ok, %Match{} = match} = StartMatch.run(game)
    assert match.croupier.id == third_player.id
    assert match.game == game
    assert length(match.stock) == 104 - 2 * 9 - 1
    assert match.discard_pile == []
    refute is_nil(match.pre_joker)
    assert match.joker == Deck.next_card(match.pre_joker)
    assert length(match.match_players) == 2
    assert Enum.all?(match.match_players, fn match_player -> length(match_player.hand) == 9 end)
  end

  test "returns error when there is 1 player" do
    game = insert(:game)
    insert(:player, game: game)

    assert {:error, %Ecto.Changeset{} = changeset} = StartMatch.run(game)
    assert %{match_players: ["should have at least 2 item(s)"]} = errors_on(changeset)
  end

  test "returns error when there are 10 players" do
    game = insert(:game)
    insert_list(10, :player, game: game)

    assert {:error, %Ecto.Changeset{} = changeset} = StartMatch.run(game)
    assert %{match_players: ["should have at most 9 item(s)"]} = errors_on(changeset)
  end
end
