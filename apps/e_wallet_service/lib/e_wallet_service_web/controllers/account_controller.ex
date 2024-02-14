defmodule EWalletServiceWeb.AccountController do
  alias EWalletService.Accounts.Deposit
  alias EWalletService.Accounts.Transfer

  use EWalletServiceWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias PhoenixAppWeb.Schemas

  action_fallback EWalletServiceWeb.FallbackController

  tags ["accounts"]

  operation :deposit,
    summary: "Deposit a value to account",
    parameters: [
      value: [in: :path, description: "Deposits value", type: :string, example: "100.00"],
      type: [
        in: :path,
        description: "Deposits type",
        type: :string,
        example: "[bank_deposit, credit_card_deposit]"
      ]
    ],
    responses: [
      ok: {"Deposit response", "application/json", Schemas.DepositResponse}
    ]

  def deposit(conn, params) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Deposit{} = deposit} <- EWalletService.deposit(user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:deposit, deposit: deposit)
    end
  end

  tags ["accounts"]

  operation :transfer,
    summary: "Transfer a value from an account to another",
    parameters: [
      value: [in: :path, description: "Deposits value", type: :string, example: "100.00"],
      to_account_id: [in: :path, description: "Account number", type: :integer, example: "123"]
    ],
    responses: [
      ok: {"Transfer response", "application/json", Schemas.TransferResponse}
    ]

  def transfer(conn, params) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Transfer{} = transfer} <- EWalletService.transfer(user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:transfer, transfer: transfer)
    end
  end

  tags ["extract"]

  operation :extract,
    summary: "Extract all operation from users account",
    responses: [
      ok: {"Transfer response", "application/json", Schemas.ExtractResponse}
    ]

  def extract(conn, params) do
    user_id = conn.assigns[:user_id]

    with {:ok, account, operations} <- EWalletService.extract(user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:extract, account: account, operations: operations)
    end
  end
end
