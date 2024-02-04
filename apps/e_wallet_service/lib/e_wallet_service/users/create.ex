defmodule EWalletService.Users.Create do
  alias EWalletService.Repo
  alias EWalletService.Users.User

  def call(params) do
    try do
      params
      |> User.changeset()
      |> Repo.insert()
    rescue
      Ecto.ConstraintError ->
        {:error, :email_already_exists}
    end
  end
end
