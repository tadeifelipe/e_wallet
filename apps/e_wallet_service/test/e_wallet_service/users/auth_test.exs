defmodule EWalletService.Users.AuthTest do
  use EWalletService.DataCase, async: true

  alias EWalletService.Users.Auth
  alias EWalletService.Users.Create
  alias EWalletService.Users.User

  setup do
    params = %{
      "name" => "Felipe",
      "email" => "felipe@gmail.com",
      "password" => "123456"
    }

    {:ok, %User{} = user_created} = Create.call(params)

    {:ok, user: user_created}
  end

  describe "run/2" do
    test "should returns an user authenticated", %{user: user} do
      assert {:ok, _user} = Auth.run(user.email, user.password)
    end

    test "should not returns an user authenticated when password is wrong", %{user: user} do
      assert {:error, :email_or_password_invalid} = Auth.run(user.email, "wrongpassword")
    end
  end
end
