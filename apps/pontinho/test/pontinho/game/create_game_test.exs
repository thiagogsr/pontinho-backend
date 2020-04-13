defmodule Pontinho.CreateGameTest do
  use Pontinho.DataCase, async: true

  alias Pontinho.{CreateGame, Game}

  test "returns the created game" do
    betting_table = [50, 100, 200, 400, 800]

    assert {:ok, %Game{} = game} = CreateGame.run(betting_table)
    assert game.betting_table == betting_table
  end

  test "returns a changeset error" do
    betting_table = [50, 100, 200]

    assert {:error, %Ecto.Changeset{} = changeset} = CreateGame.run(betting_table)
    assert %{betting_table: ["should have at least 5 item(s)"]} = errors_on(changeset)
  end
end
