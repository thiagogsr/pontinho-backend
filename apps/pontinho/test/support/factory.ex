defmodule Pontinho.Factory do
  @moduledoc """
  Tests factories
  """

  use ExMachina.Ecto, repo: Pontinho.Repo

  def game_factory do
    %Pontinho.Game{
      betting_table: [0, 50, 100, 200, 400, 800]
    }
  end

  def player_factory do
    %Pontinho.Player{
      broke_times: 0,
      name: sequence(:name, &"Player #{&1}"),
      playing: true,
      points: 99,
      sequence: sequence(:sequence, & &1),
      game: build(:game)
    }
  end

  def match_factory do
    %Pontinho.Match{
      cards: [%{value: "2", suit: "diamonds"}],
      trash: [],
      joker: %{value: "2", suit: "diamonds"},
      game: build(:game),
      croupier: build(:player)
    }
  end
end
