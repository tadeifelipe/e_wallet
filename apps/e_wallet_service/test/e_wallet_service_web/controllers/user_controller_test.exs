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
                   "balance" => "0.00"
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

    test "should returns a user authenticated", %{
      conn: conn,
      user_params: user_params
    } do
      {:ok, _} = Create.call(user_params)

      sign_in_body = %{
        "email" => Map.get(user_params, "email"),
        "password" => Map.get(user_params, "password")
      }

      response =
        conn
        |> post(~p"/api/v1/signin", sign_in_body)
        |> json_response(200)

      assert %{
               "message" => "User Authenticated",
               "user" => %{
                 "name" => "Felipe",
                 "nickname" => "felipe@gmail.com",
                 "token" => _
               }
             } = response
    end
  end
end
