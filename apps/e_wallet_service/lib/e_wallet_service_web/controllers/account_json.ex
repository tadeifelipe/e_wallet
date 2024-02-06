defmodule EWalletServiceWeb.AccountJSON do
  def deposit(%{deposit: deposit}) do
    %{
      message: "Deposit received",
      deposit: %{
        value: deposit.value,
        type: deposit.type,
        status: deposit.status
      }
    }
  end
end
