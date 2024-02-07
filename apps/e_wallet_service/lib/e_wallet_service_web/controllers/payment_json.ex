defmodule EWalletServiceWeb.PaymentJSON do

  def payment(%{payment: payment}) do
    %{
      message: "Payment received",
      payment: %{
        value: payment.value,
        status: payment.status
      }
    }
  end
end
