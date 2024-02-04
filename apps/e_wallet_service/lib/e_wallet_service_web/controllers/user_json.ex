defmodule EWalletServiceWeb.UserJSON do
  def create(%{user: user}) do
    IO.inspect(user)

    %{
      message: "User created",
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        account: %{
          number: user.account.id,
          balance: user.account.balance
        }
      }
    }
  end
end
