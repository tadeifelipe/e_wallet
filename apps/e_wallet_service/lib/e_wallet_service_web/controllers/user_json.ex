defmodule EWalletServiceWeb.UserJSON do
  def create(%{user: user}) do
    %{
      message: "User created",
      user: %{
        id: user.id,
        name: user.name,
        email: user.email
      }
    }
  end
end
