defmodule EWalletService.Accounts.AccountTest do
  use ExUnit.Case
  alias Ecto.Changeset
  alias EWalletService.Accounts.Account

  describe "changeset/1" do
    test "should return a valid changeset" do
      params = %{
        balance: 0,
        user_id: 1
      }

      assert %Changeset{valid?: true} = Account.changeset(params)
    end

    test "should not return a valid changeset when user is not provided" do
      params = %{
        balance: 0
      }

      changeset = Account.changeset(params)

      assert %Changeset{valid?: false, errors: errors} = changeset

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :user_id
        assert msg =~ "can't be blank"
      end
    end
  end
end
