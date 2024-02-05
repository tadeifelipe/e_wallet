defmodule EWalletService do
  alias EWalletService.Users.Create, as: CreateUser
  alias EWalletService.Accounts.CreateDeposit

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate deposit(user_id, params), to: CreateDeposit, as: :call
end
