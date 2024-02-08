defmodule EWalletService.Accounts.CreateTransfer do
  alias EWalletService.Repo
  alias EWalletService.Accounts.Transfer
  alias EWalletService.Accounts.Account
  alias EWalletService.RiskCheck.Client, as: RiskCheckClient

  def call(user_id, %{"to_account_id" => to_account_id, "value" => value}) do
    with %Account{} = from_account <- Repo.get_by(Account, user_id: user_id),
         %Account{} = to_account <- Repo.get(Account, to_account_id),
         {:ok, value} <- Decimal.cast(value) do
      make_transfer(from_account, to_account, value)
    else
      nil -> {:error, :not_found}
      :error -> {:error, :invalid_value}
    end
  end

  defp make_transfer(from_account, to_account, value) do
    with {:ok, _} <- risk_check_client().call() do
      %{
        from_account_id: from_account.id,
        to_account_id: to_account.id,
        value: value,
        status: "CREATED"
      }
      |> Transfer.changeset()
      |> Repo.insert()
    end
  end

  defp risk_check_client() do
    Application.get_env(:e_wallet_service, :risk_check_client, RiskCheckClient)
  end
end
