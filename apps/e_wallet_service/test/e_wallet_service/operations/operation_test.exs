defmodule EWalletService.OperationTest do
  use ExUnit.Case
  alias Ecto.Changeset
  alias EWalletService.Operations.Operation

  describe "changeset/1" do
    test "should return a valid changeset" do
      params = %{
        value: "100.00",
        type: "deposit",
        account_id: 1
      }

      assert %Changeset{valid?: true} = Operation.changeset(params)
    end

    test "should not return a valid changeset when required field is not provided" do
      params = %{
        value: "100.00",
        type: "deposit"
      }

      assert %Changeset{valid?: false, errors: errors} = Operation.changeset(params)

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :account_id
        assert msg =~ "can't be blank"
      end
    end
  end
end
