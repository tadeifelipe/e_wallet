defmodule EWalletConsumer.Operations.Create do
  require Logger
  alias Ecto.Multi
  alias EWalletConsumer.Operations.Operation
  alias EWalletService.Repo
  alias EWalletService.Accounts.{Account, Deposit, Transfer}
  alias EWalletService.Payments.Payment

  def call(%{"operation" => "deposit", "id" => id}) do
    deposit = Repo.get(Deposit, id)

    with %Account{} = account <- Repo.get(Account, deposit.account_id) do
      Multi.new()
      |> deposit(account, deposit.value)
      |> Multi.update(:new_deposit, fn _ ->
        Ecto.Changeset.change(deposit, status: "FINALIZED")
      end)
      |> Multi.insert(:operation, fn _ ->
        Operation.changeset(%{
          "value" => deposit.value,
          "type" => "deposit",
          "account_id" => account.id
        })
      end)
      |> Repo.transaction()
      |> handle_transaction(deposit)
    else
      nil -> {:error, :not_found}
    end
  end

  def call(%{"operation" => "payment", "id" => id}) do
    payment = Repo.get(Payment, id)

    with %Account{} = account <- Repo.get(Account, payment.account_id) do
      Multi.new()
      |> withdraw(account, payment.value)
      |> Multi.update(:payment, fn _ ->
        Ecto.Changeset.change(payment, status: "FINALIZED")
      end)
      |> Multi.insert(:operation, fn _ ->
        Operation.changeset(%{value: payment.value, type: "payment", account_id: account.id})
      end)
      |> Repo.transaction()
      |> handle_transaction(payment)
    else
      nil -> {:error, :not_found}
    end
  end

  def call(%{"operation" => "transfer", "id" => id}) do
    transfer = Repo.get(Transfer, id)
    from_account = Repo.get(Account, transfer.from_account_id)
    to_account = Repo.get(Account, transfer.to_account_id)

    Multi.new()
    |> withdraw(from_account, transfer.value)
    |> deposit(to_account, transfer.value)
    |> Multi.update(:transfer, fn _ ->
      Ecto.Changeset.change(transfer, status: "FINALIZED")
    end)
    |> Multi.insert(:operation, fn _ ->
      Operation.changeset(%{
        value: transfer.value,
        type: "transfer",
        account_id: from_account.id,
        note: "to_account: #{to_account.id}"
      })
    end)
    |> Repo.transaction()
    |> handle_transaction(transfer)
  end

  defp deposit(multi, to_account, value) do
    new_balance = Decimal.add(to_account.balance, value)
    changeset = Account.changeset(to_account, %{balance: new_balance})
    Multi.update(multi, :deposit, changeset)
  end

  defp withdraw(multi, from_account, value) do
    new_balance = Decimal.sub(from_account.balance, value)
    changeset = Account.changeset(from_account, %{balance: new_balance})
    Multi.update(multi, :withdraw, changeset)
  end

  defp handle_transaction({:ok, _result} = result, _), do: result

  defp handle_transaction({:error, _op, %{errors: errors}, _}, operation) do
    Logger.error(errors)

    changeset =
      Ecto.Changeset.change(operation, %{status: "ERROR", note: "Operation not accomplished"})

    Repo.update(changeset)
  end
end
