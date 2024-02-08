defmodule EWalletServiceWeb.PaymentControllerTest do
  use EWalletServiceWeb.ConnCase

  alias EWalletService.Users.Create, as: CreateUser
  alias EWalletServiceWeb.Token

  import Mox

  setup do
    params = %{
      "name" => "John",
      "email" => "john@email.com",
      "password" => "password123"
    }

    {:ok, user} = CreateUser.call(params)

    expect(EWalletService.RiskCheck.ClientMock, :call, fn ->
      {:ok, %{"status" => "Approved"}}
    end)

    EWalletServiceWeb.Kafka.PublisherMock
    |> expect(:call, fn {value, message}, _operation -> {value, message} end)

    {:ok, token: Token.sign(user)}
  end

  describe "create/2" do
    test "should create a payment successfully", %{conn: conn, token: token} do
      params = %{
        "value" => "100.00"
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/payments", params)
        |> json_response(200)

      %{
        "message" => "Payment received",
        "payment" => %{
          "value" => "100.00",
          "status" => "CREATED"
        }
      } = response
    end

    test "should not create a payment successfully when value is invalid", %{
      conn: conn,
      token: token
    } do
      params = %{
        "value" => "-100.00"
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/payments", params)
        |> json_response(400)

      %{"message" => %{"value" => ["is invalid"]}} = response
    end
  end
end
