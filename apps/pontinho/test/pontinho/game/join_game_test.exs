defmodule Pontinho.JoinGameTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{JoinGame, Player}

  test "returns the first game player" do
    game = insert(:game)

    assert {:ok, %Player{} = player} = JoinGame.run(game, "First player")
    assert player.name == "First player"
    assert player.sequence == 0
    assert player.broke_times == 0
    assert player.points == 99
  end

  test "returns the second game player" do
    game = insert(:game)

    assert {:ok, %Player{} = player1} = JoinGame.run(game, "First player")
    assert {:ok, %Player{} = player2} = JoinGame.run(game, "Second player")
    assert player1.sequence == 0
    assert player2.sequence == 1
  end

  test "returns error when player name is empty" do
    game = insert(:game)

    assert {:error, %Ecto.Changeset{} = changeset} = JoinGame.run(game, "")
    assert %{name: ["can't be blank"]} = errors_on(changeset)
  end
end
