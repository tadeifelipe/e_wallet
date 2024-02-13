defmodule EWalletServiceWeb.PaymentController do
  alias EWalletService.Payments.Payment

  use EWalletServiceWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias PhoenixAppWeb.Schemas

  action_fallback EWalletServiceWeb.FallbackController

  tags ["payments"]
  operation :create,
    summary: "Payment a value",
    parameters: [
      value: [in: :path, description: "Payment value", type: :string, example: "100.00"],
    ],
    responses: [
      ok: {"Payment response", "application/json", Schemas.PaymentResponse}
    ]

  def create(conn, params) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Payment{} = payment} <- EWalletService.payment(user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:payment, payment: payment)
    end
  end
end
