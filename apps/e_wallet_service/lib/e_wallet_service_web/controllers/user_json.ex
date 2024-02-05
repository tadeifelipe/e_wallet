defmodule EWalletServiceWeb.UserJSON do
  def create(%{user: user}) do
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

  def login(%{token: token, user: user}) do
    %{
      message: "User Authenticated",
      user: %{
        name: user.name,
        nickname: user.email,
        token: token
      }
    }
  end
end
