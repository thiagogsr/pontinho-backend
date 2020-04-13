defmodule Pontinho.CreateGame do
  @moduledoc """
  Create a new game
  """

  alias Pontinho.{Game, Repo}

  import Ecto.Changeset

  @spec run(list(pos_integer)) :: {:ok, %Game{}} | {:error, %Ecto.Changeset{}}
  def run(betting_table) do
    %Game{}
    |> change()
    |> put_change(:betting_table, betting_table)
    |> validate_length(:betting_table, min: 5, max: 11)
    |> Repo.insert()
  end
end
