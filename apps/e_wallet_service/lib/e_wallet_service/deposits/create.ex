defmodule EWalletService.Deposits.Create do
  alias EWalletService.Repo
  alias EWalletService.Deposits.Deposit
  alias EWalletService.Accounts.Account

  def call(user_id, params) do
    case Repo.get_by(Account, user_id: user_id) do
      %Account{} = account -> make_deposit(account, params)
      nil -> {:error, :account_not_found}
    end
  end

  defp make_deposit(account, params) do
    params = Map.put(params, "account_id", account.id)

    params
    |> Deposit.changeset()
    |> Repo.insert()
  end
end
