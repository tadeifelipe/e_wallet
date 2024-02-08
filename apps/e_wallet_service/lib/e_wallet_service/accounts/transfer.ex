defmodule EWalletService.Accounts.Transfer do
  use Ecto.Schema

  import Ecto.Changeset

  alias EWalletService.Accounts.Account

  @all_fields [:value, :to_account_id, :from_account_id, :status, :note]
  @required_fields [:value, :to_account_id, :from_account_id]

  schema "transfers" do
    field :value, :decimal
    field :status, :string
    field :note, :string

    belongs_to :to_account, Account, foreign_key: :to_account_id
    belongs_to :from_account, Account, foreign_key: :from_account_id

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> check_constraint(:value, name: :value_must_be_positive)
  end
end
