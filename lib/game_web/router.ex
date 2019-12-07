defmodule GameWeb.Router do
  use GameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/new", PageController, :new
    get "/play/:id", PageController, :play
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameWeb do
  #   pipe_through :api
  # end
end
