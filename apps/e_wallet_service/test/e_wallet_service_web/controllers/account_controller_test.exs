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

    {:ok, token: Token.sign(user)}
  end

  describe "deposit/2" do
    test "should create a deposit successfully", %{conn: conn, token: token} do
      expect(EWalletService.RiskCheck.ClientMock, :call, fn ->
        {:ok, %{"status" => "Approved"}}
      end)

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
          "value" => "100.00"
        }
      } = response
    end

    test "should create a deposit successfully with credit_card type deposit", %{
      conn: conn,
      token: token
    } do
      expect(EWalletService.RiskCheck.ClientMock, :call, fn ->
        {:ok, %{"status" => "Approved"}}
      end)

      params = %{
        "value" => "100.00",
        "type" => "credit_card_deposit"
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
          "value" => "100.00"
        }
      } = response
    end

    test "should return bad request when try to deposit a invalid value", %{
      conn: conn,
      token: token
    } do
      expect(EWalletService.RiskCheck.ClientMock, :call, fn ->
        {:ok, %{"status" => "Approved"}}
      end)

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
end
