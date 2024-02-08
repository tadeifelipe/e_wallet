defmodule EWalletService.Accounts.TransferTest do
  use ExUnit.Case
  alias Ecto.Changeset
  alias EWalletService.Accounts.Transfer

  describe "changeset/1" do
    test "should return a valid changeset" do
      params = %{
        from_account_id: 1,
        to_account_id: 2,
        value: "100.00"
      }

      assert %Changeset{valid?: true} = Transfer.changeset(params)
    end

    test "should not return a valid changeset when required field is not provided" do
      params = %{
        from_account_id: 1,
        value: "100.00"
      }

      assert %Changeset{valid?: false, errors: errors} = Transfer.changeset(params)

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :to_account_id
        assert msg =~ "can't be blank"
      end
    end
  end
end
