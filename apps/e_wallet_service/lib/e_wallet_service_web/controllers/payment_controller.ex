defmodule EWalletServiceWeb.PaymentController do
  alias EWalletService.Payments.Payment

  use EWalletServiceWeb, :controller

  action_fallback EWalletServiceWeb.FallbackController

  def create(conn, params) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Payment{} = payment} <- EWalletService.payment(user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:payment, payment: payment)
    end
  end
end
