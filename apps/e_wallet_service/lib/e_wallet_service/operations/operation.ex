defmodule EWalletService.Operations.Operation do
  use Ecto.Schema

  import Ecto.Changeset

  alias EWalletService.Accounts.Account

  @required_fields [:value, :type, :account_id]
  @all_fields [:value, :type, :account_id, :note]

  schema "operations" do
    field(:value, :decimal)
    field(:type, :string)
    field(:note, :string)

    belongs_to(:account, Account)

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> check_constraint(:value, name: :value_must_be_positive)
  end
end
