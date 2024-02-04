defmodule EWalletService do
  alias EWalletService.Users.Create, as: UserCreate

  @spec create_user(any()) :: any()
  defdelegate create_user(params), to: UserCreate, as: :call
end
