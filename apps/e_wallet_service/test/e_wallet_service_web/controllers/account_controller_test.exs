defmodule EWalletServiceWeb.AccountControllerTest do
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

    EWalletServiceWeb.Kafka.ProducerMock
    |> expect(:call, fn {value, message}, _operation -> {value, message} end)

    {:ok, token: Token.sign(user)}
  end

  describe "deposit/2" do
    test "should create a deposit successfully", %{conn: conn, token: token} do
      params = %{
        "value" => "100.00",
        "type" => "bank_deposit"
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/deposit", params)
        |> json_response(200)

      %{
        "message" => "Deposit received",
        "deposit" => %{
          "type" => "bank_deposit",
          "value" => "100.00",
          "status" => "CREATED"
        }
      } = response
    end

    test "should create a deposit successfully with credit_card type deposit", %{
      conn: conn,
      token: token
    } do
      params = %{
        "value" => "100.00",
        "type" => "credit_card_deposit",
        "token_card" => "token"
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/deposit", params)
        |> json_response(200)

      %{
        "message" => "Deposit received",
        "deposit" => %{
          "type" => "credit_card_deposit",
          "value" => "100.00",
          "status" => "CREATED"
        }
      } = response
    end

    test "should not create a deposit successfully with credit_card type deposit and token is not informed",
         %{
           conn: conn,
           token: token
         } do
      params = %{
        "value" => "100.00",
        "type" => "credit_card_deposit"
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/deposit", params)
        |> json_response(400)

      %{"message" => %{"token_card" => ["token card must be informed"]}} = response
    end

    test "should return bad request when try to deposit a invalid value", %{
      conn: conn,
      token: token
    } do
      params = %{
        "value" => "-100.00",
        "type" => "bank_deposit"
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/deposit", params)
        |> json_response(400)

      %{"message" => %{"value" => ["is invalid"]}} = response
    end
  end

  describe "transfer/2" do
    setup do
      john = %{
        "name" => "John",
        "email" => "userjohn@email.com",
        "password" => "password123"
      }

      joseph = %{
        "name" => "Joseph",
        "email" => "joseph@email.com",
        "password" => "password123"
      }

      {:ok, user_john} = CreateUser.call(john)
      {:ok, user_jospeh} = CreateUser.call(joseph)

      {:ok, user_jospeh: user_jospeh, token: Token.sign(user_john)}
    end

    test "should create a transfer successfully",
         %{conn: conn, token: token, user_jospeh: user_jospeh} do
      params = %{
        "value" => "100.00",
        "to_account_id" => user_jospeh.account.id
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/transfer", params)
        |> json_response(200)

      %{
        "transfer" => %{
          "from_account" => _,
          "status" => "CREATED",
          "to_account" => _,
          "value" => "100.00"
        },
        "message" => "Transfer received"
      } = response
    end

    test "should not create a transfer when to_account not exists",
         %{conn: conn, token: token} do
      params = %{
        "value" => "100.00",
        "to_account_id" => 99999
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/transfer", params)
        |> json_response(404)

      %{"message" => "Account not exists"} = response
    end

    test "should not create a transfer when value is negative",
         %{conn: conn, token: token, user_jospeh: user_jospeh} do
      params = %{
        "value" => "-100.00",
        "to_account_id" => user_jospeh.account.id
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/transfer", params)
        |> json_response(400)

      %{"message" => %{"value" => ["is invalid"]}} = response
    end

    test "should not create a transfer when value is invalid",
         %{conn: conn, token: token, user_jospeh: user_jospeh} do
      params = %{
        "value" => "invalid",
        "to_account_id" => user_jospeh.account.id
      }

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post(~p"/api/v1/accounts/transfer", params)
        |> json_response(400)

      %{"message" => "Invalid value"} = response
    end
  end
end
