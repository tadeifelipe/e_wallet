defmodule EWalletService.Payments.CreateTest do
  use EWalletService.DataCase, async: true

  alias EWalletService.Payments.Payment
  alias EWalletService.Payments.Create, as: CreatePayment
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

    EWalletServiceWeb.Kafka.ProducerMock
    |> expect(:call, fn {value, message}, _operation -> {value, message} end)

    {:ok, user: user}
  end

  describe "call/2" do
    test "should create a payment successfully", %{user: user} do
      params = %{
        "value" => "100.00"
      }

      {:ok, payment} = CreatePayment.call(user.id, params)

      payment_from_db = Repo.get(Payment, payment.id)

      assert payment_from_db == payment
    end
  end

  test "should not create a payment with negative value", %{user: user} do
    params = %{
      "value" => "-100.00"
    }

    {:error, %{valid?: false, errors: errors}} = CreatePayment.call(user.id, params)

    for error <- errors do
      assert {:value, {"is invalid", [_, {_, "value_must_be_positive"}]}} = error
    end
  end

  test "should not create a payment with invalid value", %{user: user} do
    params = %{
      "value" => "invalid"
    }

    {:error, :invalid_value} = CreatePayment.call(user.id, params)
  end
end
