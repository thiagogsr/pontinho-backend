defmodule PontinhoWeb.Router do
  use PontinhoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PontinhoWeb do
    pipe_through :api
  end
end
