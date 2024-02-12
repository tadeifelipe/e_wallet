defmodule EWalletService.Accounts.CreateDeposit do
  alias EWalletService.Repo
  alias EWalletService.Accounts.Deposit
  alias EWalletService.Accounts.Account
  alias EWalletService.RiskCheck.Client, as: RiskCheckClient
  alias EWalletServiceWeb.Kafka.Producer, as: KafkaProducer

  require Logger

  def call(user_id, %{"value" => value} = params) do
    with %Account{} = account <- Repo.get_by(Account, user_id: user_id),
         {:ok, _} <- Decimal.cast(value) do
      make_deposit(account, params)
    else
      nil -> {:error, :not_found}
      :error -> {:error, :invalid_value}
    end
  end

  defp make_deposit(account, params) do
    with {:ok, _} <- risk_check_client().call() do
      params = Map.put(params, "account_id", account.id)

      Logger.info("Making deposit")

      result =
        params
        |> set_status_created()
        |> Deposit.changeset()
        |> Repo.insert()

      publisher_kafka().call(result, :deposit)
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
