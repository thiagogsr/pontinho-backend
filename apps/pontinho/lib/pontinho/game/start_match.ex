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
    {[pre_joker], stock} = Deck.take_random_cards(deck, 1)
    joker = Deck.next_card(pre_joker)

    game
    |> match_changeset(stock, pre_joker, joker, croupier, players)
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

      %Player{} = last_croupier ->
        players
        |> sort_players(last_croupier)
        |> next_croupier()
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

  defp sort_players(players, reference) do
    {players_before, ref_and_players_after} = Enum.split_while(players, &(&1.id != reference.id))

    [_reference | players_after] = ref_and_players_after
    players_after ++ players_before ++ [reference]
  end

  defp next_croupier([first_player | tail_players]) do
    if first_player.playing, do: first_player, else: next_croupier(tail_players)
  end

  defp match_changeset(game, stock, pre_joker, joker, croupier, players) do
    %{match_players: match_players, stock: stock} = build_match_players(players, croupier, stock)

    match_attributes = %{
      match_players: match_players,
      stock: stock,
      discard_pile: [],
      pre_joker: pre_joker,
      joker: joker
    }

    %Match{}
    |> Repo.preload(:match_collections)
    |> cast(match_attributes, [:stock, :discard_pile, :pre_joker, :joker])
    |> put_assoc(:game, game)
    |> put_assoc(:croupier, croupier)
    |> cast_assoc(:match_players, with: &match_player_changeset/2)
    |> validate_length(:match_players, min: 2, max: 9)
  end

  defp build_match_players(players, croupier, stock) do
    playing_players =
      players
      |> Enum.filter(& &1.playing)
      |> sort_players(croupier)

    players_rounds = playing_players ++ playing_players ++ playing_players

    %{match_players: match_players, stock: stock} =
      Enum.reduce(players_rounds, %{match_players: %{}, stock: stock}, fn player, acc ->
        hand = get_in(acc, [:match_players, player.id, :hand]) || []
        {cards, stock} = Deck.take_random_cards(acc[:stock], 3)
        new_hand = List.flatten([hand, cards])

        acc
        |> put_in([:match_players, player.id], %{player: player, hand: new_hand})
        |> put_in([:stock], stock)
      end)

    %{match_players: Map.values(match_players), stock: stock}
  end

  defp match_player_changeset(match_player, %{player: player} = attributes) do
    match_player
    |> cast(attributes, [:hand])
    |> put_change(:points_before, player.points)
    |> put_change(:false_beat, false)
    |> put_assoc(:player, player)
  end
end
