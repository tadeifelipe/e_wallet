defmodule EWalletServiceWeb.UserController do
  use EWalletServiceWeb, :controller

  alias EWalletService.Users.User
  alias EWalletServiceWeb.Token
  alias EWalletService.Users.Auth

  action_fallback EWalletServiceWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- EWalletService.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Auth.run(email, password) do
      token = Token.sign(user)

      conn
      |> put_status(:ok)
      |> render(:login, %{token: token, user: user})
    end
  end
end
