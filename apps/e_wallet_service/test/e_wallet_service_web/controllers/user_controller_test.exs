defmodule EWalletServiceWeb.UserControllerTest do
  alias EWalletService.Users.Create
  use EWalletServiceWeb.ConnCase

  setup do
    params = %{
      "name" => "Felipe",
      "email" => "felipe@gmail.com",
      "password" => "123456"
    }

    {:ok, user_params: params}
  end

  describe "create/2" do
    test "should create an user succesfully", %{conn: conn, user_params: user_params} do
      response =
        conn
        |> post(~p"/api/v1/users", user_params)
        |> json_response(201)

      assert %{
               "message" => "User created",
               "user" => %{
                 "id" => _id,
                 "name" => "Felipe",
                 "email" => "felipe@gmail.com",
                 "account" => %{
                   "number" => _number,
                   "balance" => "1000.00"
                 }
               }
             } = response
    end

    test "should not create a user if the email already exists", %{
      conn: conn,
      user_params: user_params
    } do
      {:ok, _} = Create.call(user_params)

      response =
        conn
        |> post(~p"/api/v1/users", user_params)
        |> json_response(400)

      assert %{"message" => "E-mail already exists"} = response
    end
  end
end
