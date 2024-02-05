defmodule EWalletServiceWeb.Token do
  alias Phoenix.Token
  alias EWalletServiceWeb.Endpoint

  @sign_salt "e_wallet_salt"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id})
  end

  def verify(token), do: Token.verify(Endpoint, @sign_salt, token)
end
