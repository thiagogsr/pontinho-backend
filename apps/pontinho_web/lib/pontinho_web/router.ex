defmodule PontinhoWeb.Router do
  use PontinhoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", PontinhoWeb do
    pipe_through :api

    resources("/games", GameController, only: [:create, :show]) do
      post("/join", JoinGameController, :create)
    end

    post("/matches", MatchController, :create)
  end
end
