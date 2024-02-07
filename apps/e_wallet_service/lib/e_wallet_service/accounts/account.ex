defmodule EWalletService.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset
  alias EWalletService.Users.User
  alias EWalletService.Accounts.Deposit
  alias EWalletService.Payments.Payment

  @required_param [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal

    belongs_to :user, User
    has_many :deposit, Deposit
    has_many :payment, Payment

    timestamps()
  end

  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, @required_param)
    |> validate_required(@required_param)
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
