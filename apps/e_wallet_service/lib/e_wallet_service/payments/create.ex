defmodule EWalletService.Payments.Create do
  alias EWalletService.Repo
  alias EWalletService.Payments.Payment
  alias EWalletService.Accounts.Account
  alias EWalletServiceWeb.Kafka.Producer, as: KafkaProducer
  alias EWalletService.RiskCheck.Client, as: RiskCheckClient

  def call(user_id, %{"value" => value} = params) do
    with %Account{} = account <- Repo.get_by(Account, user_id: user_id),
         {:ok, _} <- Decimal.cast(value) do
      make_payment(account, params)
    else
      nil -> {:error, :not_found}
      :error -> {:error, :invalid_value}
    end
  end

  defp make_payment(account, params) do
    with {:ok, _} <- risk_check_client().call() do
      params = Map.put(params, "account_id", account.id)

      result =
        params
        |> set_status_created()
        |> Payment.changeset()
        |> Repo.insert()

      publisher_kafka().call(result, :payment)
    end
  end

  defp set_status_created(params), do: Map.put(params, "status", "CREATED")

  defp publisher_kafka() do
    Application.get_env(:e_wallet_service, :publisher_kafka, KafkaProducer)
  end

  defp risk_check_client() do
    Application.get_env(:e_wallet_service, :risk_check_client, RiskCheckClient)
  end
end
