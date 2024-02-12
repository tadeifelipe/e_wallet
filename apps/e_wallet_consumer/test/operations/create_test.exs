defmodule EWalletConsumer.CreateTest do
  use ExUnit.Case

  alias EWalletService.Accounts.{CreateDeposit, CreateTransfer}
  alias EWalletService.Users.Create, as: CreateUser
  alias EWalletService.Payments.Create, as: CreatePayment
  alias EWalletConsumer.Operations.Create, as: CreateOperation
  alias EWalletConsumer.Operations.Operation
  alias EWalletService.Repo
  alias EWalletService.Accounts.Account

  import Mox

  setup do
    return_risk_check = %{
      "status" => "Approved"
    }

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    EWalletService.RiskCheck.ClientMock
    |> expect(:call, fn -> {:ok, return_risk_check} end)

    EWalletServiceWeb.Kafka.ProducerMock
    |> expect(:call, fn {value, message}, _operation -> {value, message} end)

    params = %{
      "name" => "John",
      "email" => "john@email.com",
      "password" => "password123"
    }

    {:ok, user} = CreateUser.call(params)

    {:ok, user: user}
  end

  describe "call/1" do
    test "should create a deposit operation", %{user: user} do
      account_id = user.account.id

      params = %{
        "account_id" => account_id,
        "type" => "bank_deposit",
        "value" => "100.00"
      }

      {:ok, deposit} = CreateDeposit.call(user.id, params)

      params_operation = %{
        "operation" => "deposit",
        "id" => deposit.id
      }

      {:ok, %{operation: operation}} = CreateOperation.call(params_operation)

      operation_from_db = Repo.get(Operation, operation.id)

      assert operation_from_db == operation
    end

    test "should create a payment operation", %{user: user} do
      return_risk_check = %{
        "status" => "Approved"
      }

      EWalletService.RiskCheck.ClientMock
      |> expect(:call, 2, fn -> {:ok, return_risk_check} end)

      EWalletServiceWeb.Kafka.ProducerMock
      |> expect(:call, 2, fn {value, message}, _operation -> {value, message} end)

      params = %{
        "account_id" => user.account.id,
        "type" => "bank_deposit",
        "value" => "100.00"
      }

      {:ok, deposit} = CreateDeposit.call(user.id, params)

      params_operation = %{
        "operation" => "deposit",
        "id" => deposit.id
      }

      {:ok, _} = CreateOperation.call(params_operation)

      params = %{
        "value" => "50.00"
      }

      {:ok, payment} = CreatePayment.call(user.id, params)

      params_operation = %{
        "operation" => "payment",
        "id" => payment.id
      }

      {:ok, %{operation: operation}} = CreateOperation.call(params_operation)

      operation_from_db = Repo.get(Operation, operation.id)

      assert operation_from_db == operation
    end

    test "should create a transfer operation", %{user: user} do
      return_risk_check = %{
        "status" => "Approved"
      }

      EWalletService.RiskCheck.ClientMock
      |> expect(:call, 2, fn -> {:ok, return_risk_check} end)

      EWalletServiceWeb.Kafka.ProducerMock
      |> expect(:call, 2, fn {value, message}, _operation -> {value, message} end)

      params = %{
        "account_id" => user.account.id,
        "type" => "bank_deposit",
        "value" => "100.00"
      }

      {:ok, deposit} = CreateDeposit.call(user.id, params)

      params_operation = %{
        "operation" => "deposit",
        "id" => deposit.id
      }

      {:ok, _} = CreateOperation.call(params_operation)

      params = %{
        "name" => "Joseph",
        "email" => "joseph@email.com",
        "password" => "password123"
      }

      {:ok, user_joseph} = CreateUser.call(params)

      params = %{
        "user_id" => user.id,
        "to_account_id" => user_joseph.account.id,
        "value" => "50.00"
      }

      {:ok, transfer} = CreateTransfer.call(user.id, params)

      params_operation_transfer = %{
        "operation" => "transfer",
        "id" => transfer.id
      }

      {:ok, %{operation: operation}} = CreateOperation.call(params_operation_transfer)

      operation_from_db = Repo.get(Operation, operation.id)

      assert operation_from_db == operation

      user_account = Repo.get(Account, user.account.id)
      user_joseph_account = Repo.get(Account, user_joseph.account.id)

      balance = Map.get(user_account, :balance)
      balance_joseph = Map.get(user_joseph_account, :balance)

      assert balance == Decimal.new("50.00")
      assert balance_joseph == Decimal.new("50.00")
    end
  end
end
