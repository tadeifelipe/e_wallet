defmodule EWalletServiceWeb.AccountJSON do

  def deposit(%{deposit: deposit}) do
    IO.inspect(deposit)
    %{
      message: "Deposit received",
      deposit: %{
        value: deposit.value
      }
    }
  end
end
