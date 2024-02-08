defmodule EWalletService.Repo.Migrations.AddPaymentTable do
  use Ecto.Migration

  def change do
    create table("payments") do
      add :value, :decimal, null: false
      add :status, :string
      add :note, :string

      add :account_id, references(:accounts)

      timestamps()
    end

    create constraint(:payments, :value_must_be_positive, check: "value > 0")
  end
end
