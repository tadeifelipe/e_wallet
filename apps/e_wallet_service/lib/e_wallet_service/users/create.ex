defmodule EWalletService.Users.Create do
  alias EWalletService.Repo
  alias EWalletService.Users.User
  alias EWalletService.Accounts.Account
  alias Ecto.Multi

  @start_balance "0.00"

  def call(params) do
    try do
      Multi.new()
      |> Multi.insert(:create_user, User.changeset(params))
      |> Multi.run(:create_account, fn repo, %{create_user: user} ->
        insert_account(repo, user)
      end)
      |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
        preload_data(repo, user)
      end)
      |> run_transaction()
    rescue
      Ecto.ConstraintError ->
        {:error, :email_already_exists}
    end
  end

  defp insert_account(repo, user) do
    Account.changeset(%{user_id: user.id, balance: @start_balance})
    |> repo.insert
  end

  defp preload_data(repo, user) do
    {:ok, repo.preload(user, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
