defmodule Pontinho.StartMatch do
  @moduledoc """
  Start a match
  """

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Pontinho.{CreateDeck, Deck, Game, Match, Player, Repo}

  @spec run(%Game{}) :: {:ok, %Match{}} | {:error, %Ecto.Changeset{}}
  def run(game) do
    deck = CreateDeck.run()
    players = get_players(game)
    croupier = get_croupier(game, players)
    {[joker], deck} = Deck.take_random_cards(deck, 1)

    game
    |> match_changeset(deck, joker, croupier, players)
    |> Repo.insert()
  end

  defp get_players(%{id: game_id} = _game) do
    query = from(p in Player, where: p.game_id == ^game_id, order_by: p.sequence)
    Repo.all(query)
  end

  defp get_croupier(game, [first_player | _rest] = players) do
    case get_last_croupier(game) do
      nil ->
        first_player

      %Player{sequence: sequence} ->
        Enum.find(players, first_player, &(&1.sequence == sequence + 1))
    end
  end

  defp get_last_croupier(%{id: game_id} = _game) do
    query =
      from(
        m in Match,
        join: c in assoc(m, :croupier),
        where: m.game_id == ^game_id,
        order_by: [desc: m.inserted_at],
        limit: 1,
        select: c
      )

    Repo.one(query)
  end

  defp match_changeset(game, deck, joker, croupier, players) do
    %{match_players: match_players, deck: deck} = build_match_players(players, deck)
    match_attributes = %{match_players: match_players, cards: deck, trash: [], joker: joker}

    %Match{}
    |> cast(match_attributes, [:cards, :trash, :joker])
    |> put_assoc(:game, game)
    |> put_assoc(:croupier, croupier)
    |> cast_assoc(:match_players, with: &match_player_changeset/2)
    |> validate_length(:match_players, min: 2, max: 9)
  end

  defp build_match_players(players, deck) do
    players_rounds = List.flatten([players, players, players])

    %{match_players: match_players, deck: deck} =
      Enum.reduce(players_rounds, %{match_players: %{}, deck: deck}, fn player, acc ->
        current_cards = get_in(acc, [:match_players, player.id, :cards]) || []
        {taked_cards, deck} = Deck.take_random_cards(acc[:deck], 3)
        new_cards = List.flatten([current_cards, taked_cards])

        acc
        |> put_in([:match_players, player.id], %{player: player, cards: new_cards})
        |> put_in([:deck], deck)
      end)

    %{match_players: Map.values(match_players), deck: deck}
  end

  defp match_player_changeset(match_player, %{player: player} = attributes) do
    match_player
    |> cast(attributes, [:cards])
    |> put_assoc(:player, player)
  end
end
