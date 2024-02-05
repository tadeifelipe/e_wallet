defmodule EWalletService do
  alias EWalletService.Users.Create, as: CreateUser
  alias EWalletService.Deposits.Create, as: CreateBankDeposit

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate deposit(user_id, params), to: CreateBankDeposit, as: :call
end
