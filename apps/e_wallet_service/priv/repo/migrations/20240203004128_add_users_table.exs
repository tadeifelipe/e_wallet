defmodule EWalletService.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password, :string, virtual: true
      add :password_hash, :string, null: false

      timestamps()
    end
  end
end
