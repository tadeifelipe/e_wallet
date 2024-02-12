defmodule EWalletConsumer.Repo.Migrations.AddOperationTable do
  use Ecto.Migration

  def change do
    create table("operations") do
      add :value, :decimal, null: false
      add :type, :string,  null: false
      add :note, :string

      add :account_id, references(:accounts)

      timestamps()
    end

  create constraint(:operations, :value_must_be_positive, check: "value > 0")
  end
end
