defmodule Project1Web.Router do
  use Project1Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Project1Web.Plugs.FetchSession
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Project1Web do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", Project1Web do
  #   pipe_through :api
  # end
end
