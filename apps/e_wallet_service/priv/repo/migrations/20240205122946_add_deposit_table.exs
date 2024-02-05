defmodule EWalletService.Repo.Migrations.AddDepositTable do
  use Ecto.Migration

  def change do
    create  table("deposits") do
      add :type, :string, null: false
      add :value, :decimal, null: false
      add :token_card, :string
      add :account_id, references(:accounts)
      add :accomplished, :boolean

      timestamps()
    end

    create constraint(:deposits, :value_must_be_positive, check: "value >0")
  end
end
