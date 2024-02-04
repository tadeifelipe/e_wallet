defmodule EWalletService.Users.CreateTest do
  alias EWalletService.Users.User
  use EWalletService.DataCase, async: true

  alias EWalletService.Users.Create

  describe "call/1" do
    test "should create a user successfully" do
      params = %{
        "name" => "John",
        "email" => "john@email.com",
        "password" => "password123"
      }

      skip_field = [:password]

      {:ok, %User{} = user_created} = Create.call(params)

      user_from_db = Repo.get(User, user_created.id)

      for field <- params, field not in skip_field do
        actual = Map.get(user_from_db, field)
        expected = Map.get(user_created, field)

        assert actual == expected
      end
    end
  end
end
