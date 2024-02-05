defmodule EWalletService.Accounts.Deposit do
  use Ecto.Schema

  import Ecto.Changeset

  alias EWalletService.Accounts.Account

  @required_fields [:value, :type, :account_id]
  @valid_types ["bank_deposit", "credit_card_deposit"]

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
    |> check_type()
  end

  defp check_type(changeset) do
    type = get_field(changeset, :type)

    case Enum.member?(@valid_types, type) do
      true -> changeset
      false -> add_error(changeset, :type, "type deposit invalid")
    end
  end
end
