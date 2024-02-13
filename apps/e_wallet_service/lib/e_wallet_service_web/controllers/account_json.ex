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

  def transfer(%{transfer: transfer}) do
    %{
      message: "Transfer received",
      transfer: %{
        value: transfer.value,
        to_account: transfer.to_account_id,
        from_account: transfer.from_account_id,
        status: transfer.status
      }
    }
  end

  def extract(%{account: account, operations: operations}) do
    %{
      balance: account.balance,
      operations: operations
    }
  end
end
