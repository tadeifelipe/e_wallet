defmodule EWalletService.Users.Auth do
  alias EWalletService.Repo
  alias EWalletService.Users.User

  def run(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = user -> verify_password(user, password)
      nil -> {:error, :email_or_password_invalid}
    end
  end

  defp verify_password(user, password) do
    case Pbkdf2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, :email_or_password_invalid}
    end
  end
end
