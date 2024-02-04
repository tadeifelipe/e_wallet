defmodule EWalletService.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> add_password_hash()
  end

  defp add_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, %{password_hash: Pbkdf2.hash_pwd_salt(password)})
  end

  defp add_password_hash(changeset), do: changeset
end
