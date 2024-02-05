defmodule EWalletServiceWeb.AccountController do
  alias EWalletService.Accounts.Deposit

  use EWalletServiceWeb, :controller

  action_fallback EWalletServiceWeb.FallbackController

  def deposit(conn, params) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Deposit{} = deposit} <- EWalletService.deposit(user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:deposit, deposit: deposit)
    end
  end
end
