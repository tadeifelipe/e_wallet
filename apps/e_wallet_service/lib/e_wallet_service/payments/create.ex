defmodule EWalletService.Payments.Create do
  alias EWalletService.Repo
  alias EWalletService.Payments.Payment
  alias EWalletService.Accounts.Account

  def call(user_id, params) do
    case Repo.get_by(Account, user_id: user_id) do
      %Account{} = account -> make_payment(account, params)
      nil -> {:error, :account_not_found}
    end
  end

  defp make_payment(account, params) do
    with {:ok, _} <- risk_check_client().call() do
      params = Map.put(params, "account_id", account.id)

      params
      |> set_status_created()
      |> Payment.changeset()
      |> Repo.insert()
    end
  end

  defp set_status_created(params), do: Map.put(params, "status", "CREATED")

  defp risk_check_client() do
    Application.get_env(:e_wallet_service, :risk_check_client, RiskCheckClient)
  end
end
