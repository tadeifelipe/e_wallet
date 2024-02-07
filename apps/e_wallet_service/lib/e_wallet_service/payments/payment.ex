defmodule EWalletService.Payments.Payment do
  use Ecto.Schema

  import Ecto.Changeset

  alias EWalletService.Accounts.Account

  @all_fields [:value, :status, :account_id]

  schema "payments" do
    field :value, :decimal
    field :status, :string

    belongs_to :account, Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@all_fields)
    |> check_constraint(:value, name: :value_must_be_positive)
  end
end
