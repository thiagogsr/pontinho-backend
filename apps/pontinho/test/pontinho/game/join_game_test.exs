defmodule Pontinho.JoinGameTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{JoinGame, Player}

  test "returns the first game player" do
    game = insert(:game)

    assert {:ok, %Player{} = player} = JoinGame.run(game, "First player", host: true)
    assert player.name == "First player"
    assert player.sequence == 0
    assert player.broke_times == 0
    assert player.points == 99
    assert player.host
  end

  test "returns the second game player" do
    game = insert(:game)

    assert {:ok, %Player{} = player1} = JoinGame.run(game, "First player", host: true)
    assert {:ok, %Player{} = player2} = JoinGame.run(game, "Second player")
    assert player1.sequence == 0
    assert player1.host
    assert player2.sequence == 1
    refute player2.host
  end

  test "returns error when player name is empty" do
    game = insert(:game)

    assert {:error, %Ecto.Changeset{} = changeset} = JoinGame.run(game, "")
    assert %{name: ["can't be blank"]} = errors_on(changeset)
  end

  test "returns error when game is already started" do
    game = insert(:game)
    insert(:match, game: game)

    assert {:error, "game already started"} = JoinGame.run(game, "Player name")
  end
end
