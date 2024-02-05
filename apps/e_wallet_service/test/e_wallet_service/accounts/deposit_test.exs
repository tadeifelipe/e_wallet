defmodule EWalletService.Accounts.DepositTest do
  use ExUnit.Case
  alias Ecto.Changeset
  alias EWalletService.Accounts.Deposit

  describe "changeset/1" do
    test "should return a valid changeset" do
      params = %{
        account_id: 1,
        type: "bank_deposit",
        value: "100.00"
      }

      assert %Changeset{valid?: true} = Deposit.changeset(params)
    end

    test "should return a valid changeset when type is credit_card" do
      params = %{
        account_id: 1,
        type: "credit_card_deposit",
        value: "100.00"
      }

      assert %Changeset{valid?: true} = Deposit.changeset(params)
    end

    test "should not return a valid changeset when required field is not provided" do
      params = %{
        type: "credit_card_deposit",
        value: "100.00"
      }

      assert %Changeset{valid?: false, errors: errors} = Deposit.changeset(params)

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :account_id
        assert msg =~ "can't be blank"
      end
    end

    test "should not return a valid changeset when type is invalid" do
      params = %{
        account_id: 1,
        type: "deposit_type_invalid",
        value: "100.00"
      }

      assert %Changeset{valid?: false, errors: errors} = Deposit.changeset(params)

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :type
        assert msg =~ "type deposit invalid"
      end
    end
  end
end
