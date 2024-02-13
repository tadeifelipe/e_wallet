defmodule EWalletServiceWeb.Router do
  use EWalletServiceWeb, :router

  @swagger_ui_config [
    path: "/openapi",
    default_model_expand_depth: 3,
    display_operation_id: true
  ]

  def swagger_ui_config, do: @swagger_ui_config

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: EWalletService.EWalletSpec
  end

  pipeline :auth do
    plug EWalletServiceWeb.Plugs.AuthAccessPipeline
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, @swagger_ui_config
  end

  scope "/api/v1", EWalletServiceWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/signin", UserController, :sign_in
  end

  scope "/openapi" do
    pipe_through :api
    get "/", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api/v1", EWalletServiceWeb do
    pipe_through :auth

    post "/accounts/deposit", AccountController, :deposit
    post "/accounts/transfer", AccountController, :transfer
    get "/accounts/extract", AccountController, :extract
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
