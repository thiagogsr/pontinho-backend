defmodule Pontinho.Factory do
  @moduledoc """
  Tests factories
  """

  use ExMachina.Ecto, repo: Pontinho.Repo

  @deck Pontinho.CreateDeck.run()

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
      stock: @deck,
      discard_pile: [],
      pre_joker: %{"value" => "A", "suit" => "diamonds", "deck" => 1},
      joker: %{"value" => "2", "suit" => "diamonds", "deck" => 2},
      game: build(:game),
      croupier: build(:player)
    }
  end

  def match_player_factory do
    %Pontinho.MatchPlayer{
      hand: Enum.take_random(@deck, 9),
      false_beat: false,
      match: build(:match),
      player: build(:player)
    }
  end

  def match_collection_factory do
    %Pontinho.MatchCollection{
      cards: [
        %{"value" => "2", "suit" => "diamonds", "deck" => 1, "order" => 0},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1, "order" => 1},
        %{"value" => "4", "suit" => "diamonds", "deck" => 1, "order" => 2}
      ],
      type: "sequence",
      match: build(:match),
      dropped_by: build(:match_player)
    }
  end

  def match_event_factory do
    %Pontinho.MatchEvent{
      cards: [],
      type: "BUY",
      match: build(:match),
      match_player: build(:match_player)
    }
  end
end
