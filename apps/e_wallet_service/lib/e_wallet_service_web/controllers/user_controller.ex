defmodule EWalletServiceWeb.UserController do
  use EWalletServiceWeb, :controller

  use OpenApiSpex.ControllerSpecs

  alias EWalletService.Users.User
  alias EWalletServiceWeb.Token
  alias EWalletService.Users.Auth

  alias PhoenixAppWeb.Schemas

  action_fallback EWalletServiceWeb.FallbackController

  tags ["users"]
  operation :create,
    summary: "Create user",
    parameters: [
      name: [in: :path, description: "Users name", type: :string, example: "Joe"],
      email: [in: :path, description: "Users email", type: :string, example: "joe@email.com"],
      password: [in: :path, description: "Users password", type: :string, example: "password123556"]
    ],
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse}
    ]

  def create(conn, params) do
    with {:ok, %User{} = user} <- EWalletService.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  tags ["users"]
  operation :sign_in,
    summary: "Signin",
    parameters: [
      email: [in: :path, description: "Users email", type: :string, example: "joe@email.com"],
      password: [in: :path, description: "Users password", type: :string, example: "password123556"]
    ],
    request_body: {"User params", "application/json"},
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse}
    ]

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Auth.run(email, password) do
      token = Token.sign(user)

      conn
      |> put_status(:ok)
      |> render(:login, %{token: token, user: user})
    end
  end
end
