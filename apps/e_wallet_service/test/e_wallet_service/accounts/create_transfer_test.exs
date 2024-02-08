defmodule EWalletService.Accounts.CreateTransferTest do
  use EWalletService.DataCase, async: true

  alias EWalletService.Accounts.Transfer
  alias EWalletService.Accounts.CreateTransfer
  alias EWalletService.Users.Create, as: CreateUser

  import Mox

  setup do
    john = %{
      "name" => "John",
      "email" => "john@email.com",
      "password" => "password123"
    }

    joseph = %{
      "name" => "Joseph",
      "email" => "joseph@email.com",
      "password" => "password123"
    }

    return_risk_check = %{
      "status" => "Approved"
    }

    {:ok, user_john} = CreateUser.call(john)
    {:ok, user_jospeh} = CreateUser.call(joseph)

    {:ok, user_john: user_john, user_jospeh: user_jospeh, body: return_risk_check}
  end

  describe "call/2" do
    test "should create a transfer successfully", %{
      user_john: user_john,
      user_jospeh: user_jospeh,
      body: body
    } do
      EWalletService.RiskCheck.ClientMock
      |> expect(:call, fn -> {:ok, body} end)

      params = %{
        "to_account_id" => user_jospeh.account.id,
        "value" => "100.00"
      }

      {:ok, transfer} = CreateTransfer.call(user_john.id, params)

      transfer_from_db = Repo.get(Transfer, transfer.id)

      assert transfer == transfer_from_db
    end

    test "should not create a transfer when to_account not exists", %{
      user_john: user_john,
      body: body
    } do
      EWalletService.RiskCheck.ClientMock
      |> expect(:call, fn -> {:ok, body} end)

      params = %{
        "to_account_id" => 999_999,
        "value" => "100.00"
      }

      assert {:error, :not_found} = CreateTransfer.call(user_john.id, params)
    end

    test "should not create a transfer when value is negative", %{
      user_john: user_john,
      user_jospeh: user_jospeh,
      body: body
    } do
      EWalletService.RiskCheck.ClientMock
      |> expect(:call, fn -> {:ok, body} end)

      params = %{
        "to_account_id" => user_jospeh.account.id,
        "value" => "-100.00"
      }

      {:error, %{valid?: false, errors: errors}} = CreateTransfer.call(user_john.id, params)

      for error <- errors do
        assert {:value, {"is invalid", [_, {_, "value_must_be_positive"}]}} = error
      end
    end

    test "should not create a transfer when value is invalid", %{
      user_john: user_john,
      user_jospeh: user_jospeh,
      body: body
    } do
      EWalletService.RiskCheck.ClientMock
      |> expect(:call, fn -> {:ok, body} end)

      EWalletService.RiskCheck.ClientMock
      |> expect(:call, fn -> {:ok, body} end)

      params = %{
        "to_account_id" => user_jospeh.account.id,
        "value" => "invalid"
      }

      {:error, :invalid_value} = CreateTransfer.call(user_john.id, params)
    end
  end
end
