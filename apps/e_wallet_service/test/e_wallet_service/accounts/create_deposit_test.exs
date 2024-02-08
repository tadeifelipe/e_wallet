defmodule EWalletService.Accounts.CreateDepositTest do
  use EWalletService.DataCase, async: true

  alias EWalletService.Accounts.Deposit
  alias EWalletService.Accounts.CreateDeposit
  alias EWalletService.Users.Create, as: CreateUser

  import Mox

  setup do
    params = %{
      "name" => "John",
      "email" => "john@email.com",
      "password" => "password123"
    }

    return_risk_check = %{
      "status" => "Approved"
    }

    {:ok, user} = CreateUser.call(params)

    EWalletService.RiskCheck.ClientMock
    |> expect(:call, fn -> {:ok, return_risk_check} end)

    EWalletServiceWeb.Kafka.PublisherMock
    |> expect(:call, fn {value, message}, _operation -> {value, message} end)

    {:ok, user: user}
  end

  describe "call/2" do
    test "should create a deposit successfully", %{user: user} do
      params = %{
        "account_id" => user.account.id,
        "type" => "bank_deposit",
        "value" => "100.00"
      }

      {:ok, deposit} = CreateDeposit.call(user.id, params)

      deposit_from_db = Repo.get(Deposit, deposit.id)

      for field <- params do
        actual = Map.get(deposit, field)
        expected = Map.get(deposit_from_db, field)

        assert actual == expected
      end

      assert deposit_from_db.status == deposit.status
    end

    test "should create a deposit successfully with credit_card_deposit type", %{
      user: user
    } do
      params = %{
        "account_id" => user.account.id,
        "type" => "credit_card_deposit",
        "token_card" => "token",
        "value" => "100.00"
      }

      {:ok, deposit} = CreateDeposit.call(user.id, params)

      deposit_from_db = Repo.get(Deposit, deposit.id)

      for field <- params do
        actual = Map.get(deposit, field)
        expected = Map.get(deposit_from_db, field)

        assert actual == expected
      end

      assert deposit_from_db.status == deposit.status
    end

    test "should not create a deposit with negative value", %{user: user} do
      params = %{
        "account_id" => user.account.id,
        "type" => "credit_card_deposit",
        "token_card" => "token",
        "value" => "-100.00"
      }

      {:error, %{valid?: false, errors: errors}} = CreateDeposit.call(user.id, params)

      for error <- errors do
        assert {:value, {"is invalid", [_, {_, "value_must_be_positive"}]}} = error
      end
    end

    test "should not create a deposit with invalid value", %{user: user} do
      params = %{
        "account_id" => user.account.id,
        "type" => "credit_card_deposit",
        "token_card" => "token",
        "value" => "invalid"
      }

      {:error, :invalid_value} = CreateDeposit.call(user.id, params)
    end
  end
end
