defmodule EWalletService.Deposits.Deposit do
  use Ecto.Schema

  import Ecto.Changeset

  alias EWalletService.Accounts.Account

  @required_fields [:value, :type, :account_id]

  schema "deposits" do
    field :type, :string
    field :value, :decimal
    field :token_card, :string
    field :accomplished, :boolean, default: false

    belongs_to :account, Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> check_constraint(:value, name: :value_must_be_positive)
  end
end
