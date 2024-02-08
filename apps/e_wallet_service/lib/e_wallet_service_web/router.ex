defmodule EWalletServiceWeb.Router do
  use EWalletServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug EWalletServiceWeb.Plugs.AuthAccessPipeline
    plug :accepts, ["json"]
  end

  scope "/api/v1", EWalletServiceWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/signin", UserController, :sign_in
  end

  scope "/api/v1", EWalletServiceWeb do
    pipe_through :auth

    post "/accounts/deposit", AccountController, :deposit
    post "/accounts/transfer", AccountController, :transfer
    post "/payments", PaymentController, :create
  end

  if Application.compile_env(:e_wallet_service, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: EWalletServiceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
