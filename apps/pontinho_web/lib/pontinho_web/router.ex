defmodule PontinhoWeb.Router do
  use PontinhoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", PontinhoWeb do
    pipe_through :api

    post("/games", GameController, :create)
  end
end
