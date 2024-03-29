defmodule EWalletService do
  alias EWalletService.Users.Create, as: CreateUser
  alias EWalletService.Accounts.CreateDeposit
  alias EWalletService.Payments.Create, as: CreatePayment
  alias EWalletService.Accounts.CreateTransfer
  alias EWalletService.Accounts.Extract

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate deposit(user_id, params), to: CreateDeposit, as: :call
  defdelegate payment(user_id, params), to: CreatePayment, as: :call
  defdelegate transfer(user_id, params), to: CreateTransfer, as: :call
  defdelegate extract(user_id, params), to: Extract, as: :call
end
