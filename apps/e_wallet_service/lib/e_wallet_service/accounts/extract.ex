defmodule EWalletService.Accounts.Extract do
  alias EWalletService.Repo
  alias EWalletService.Accounts.Account
  alias EWalletService.Operations.Operation
  import Ecto.Query

  def call(user_id, _) do
    with %Account{} = account <- Repo.get_by(Account, user_id: user_id) do
      query =
        from o in Operation,
          where: o.account_id == ^account.id,
          order_by: [desc: o.inserted_at],
          select: [:type, :value, :inserted_at]

      operations = Repo.all(query)

      {:ok, account, operations}
    else
      nil -> {:error, :not_found}
    end
  end
end
