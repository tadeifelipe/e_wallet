defmodule EWalletService.Users.Create do
  alias EWalletService.Repo
  alias EWalletService.Users.User

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
