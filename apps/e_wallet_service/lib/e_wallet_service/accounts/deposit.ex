defmodule EWalletService.Accounts.Deposit do
  use Ecto.Schema

  import Ecto.Changeset

  alias EWalletService.Accounts.Account

  @all_fields [:type, :value, :token_card, :status, :account_id]
  @required_fields [:value, :type, :account_id]
  @valid_types ["bank_deposit", "credit_card_deposit"]

  schema "deposits" do
    field :type, :string
    field :value, :decimal
    field :token_card, :string
    field :status, :string

    belongs_to :account, Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> check_constraint(:value, name: :value_must_be_positive)
    |> check_type()
    |> check_credit_card_token()
  end

  defp check_type(changeset) do
    type = get_field(changeset, :type)

    case Enum.member?(@valid_types, type) do
      true -> changeset
      false -> add_error(changeset, :type, "type deposit invalid")
    end
  end

  defp check_credit_card_token(changeset) do
    case get_field(changeset, :type) do
      "credit_card_deposit" -> check_token_card(changeset)
      _ -> changeset
    end
  end

  defp check_token_card(changeset) do
    case field_missing?(changeset, :token_card) do
      true -> add_error(changeset, :token_card, "token card must be informed")
      false -> changeset
    end
  end
end
