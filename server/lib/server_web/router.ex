defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :verify do
    plug Server.Users.VerifyPipeline
  end

  pipeline :reset do
    plug Server.Users.ResetPasswordPipeline
  end

  pipeline :auth do
    plug Server.Users.Pipeline
  end

  pipeline :ensure_auth do
    plug Server.Users.EnsureAuthPipeline
  end

  scope "/api", ServerWeb do
    pipe_through [
      :api
    ]

    resources "/clients", ClientController, except: [:new, :edit]
    resources "/categories", CategoryController, except: [:new, :edit]
    resources "/products", ProductController, except: [:new, :edit]
  end

  scope "/api", ServerWeb do
    pipe_through [
      :api,
      :verify
    ]

    post "/verify", SessionController, :verify_token
  end

  scope "/api", ServerWeb do
    pipe_through [
      :api,
      :reset
    ]

    post "/reset-password", UserController, :reset_password
  end

  scope "/api", ServerWeb do
    pipe_through [
      :api,
      :auth
    ]

    post "/register", SessionController, :create
    post "/login", SessionController, :login
  end

  scope "/api", ServerWeb do
    pipe_through [:api, :ensure_auth]

    get "/reset-token", UserController, :get_reset_token
    get "/protected", AuthController, :protected
    post "/logout", SessionController, :logout
    resources "/users", UserController, except: [:new, :edit]
    post "/refresh", SessionController, :refresh_token
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ServerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
