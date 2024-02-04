defmodule EWalletServiceWeb.UserController do
  use EWalletServiceWeb, :controller

  alias EWalletService.Users.User

  action_fallback EWalletServiceWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- EWalletService.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end
end
