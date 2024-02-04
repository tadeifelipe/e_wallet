defmodule EWalletService.Users.UserTest do
  use ExUnit.Case
  alias Ecto.Changeset
  alias EWalletService.Users.User

  @schema_fields [
    :name,
    :email,
    :password,
    :password_hash
  ]

  describe "changeset/1" do
    test "should return a valid changeset" do
      params = %{
        "name" => "John",
        "email" => "john@email.com",
        "password" => "password123"
      }

      skip_field = [:password_hash]

      changeset = User.changeset(params)

      assert %Changeset{valid?: true, changes: changes} = changeset

      for field <- @schema_fields, field not in skip_field do
        actual = Map.get(changes, field)
        expected = params[Atom.to_string(field)]

        assert actual == expected
      end
    end

    test "should not return a valid changeset when required fields is missing" do
      params = %{
        "name" => "John",
        "password" => "password123"
      }

      changeset = User.changeset(params)
      assert %Changeset{valid?: false, errors: errors} = changeset

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :email
        assert msg =~ "can't be blank"
      end
    end

    test "should not return a valid changeset when password length is invalid" do
      params = %{
        "name" => "John",
        "email" => "john@email.com",
        "password" => "123"
      }

      changeset = User.changeset(params)
      assert %Changeset{valid?: false, errors: errors} = changeset

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :password
        assert String.contains?(msg, "should be at least")
      end
    end

    test "should not return a valid changeset when email has invalid format" do
      params = %{
        "name" => "John",
        "email" => "johemail.com",
        "password" => "password123"
      }

      changeset = User.changeset(params)
      assert %Changeset{valid?: false, errors: errors} = changeset

      for error <- errors do
        {field, {msg, _}} = error

        assert field == :email
        assert String.contains?(msg, "has invalid format")
      end
    end
  end
end
