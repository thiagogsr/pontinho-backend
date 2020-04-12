defmodule Pontinho.Factory do
  use ExMachina.Ecto, repo: Pontinho.Repo

  def game_factory do
    %Pontinho.Game{
      betting_table: [0, 50, 100, 200, 400, 800],
      status: "waiting_players"
    }
  end
end
