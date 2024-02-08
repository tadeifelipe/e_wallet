defmodule EWalletService.Repo.Migrations.AddTransferTable do
  use Ecto.Migration

  def change do
    create table("transfers") do
      add :value, :decimal, null: false
      add :status, :string
      add :note, :string

      add :to_account_id, references(:accounts)
      add :from_account_id, references(:accounts)

      timestamps()
    end

    create constraint(:transfers, :value_must_be_positive, check: "value > 0")
  end
end
