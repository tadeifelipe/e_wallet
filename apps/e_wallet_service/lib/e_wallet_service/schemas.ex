defmodule PhoenixAppWeb.Schemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule User do
    OpenApiSpex.schema(%{
      title: "User",
      description: "A user of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "User ID"},
        name: %Schema{type: :string, description: "User name", pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/},
        email: %Schema{type: :string, description: "Email address", format: :email},
        password: %Schema{type: :string, description: "Birth date", format: :date},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :email, :password],
      example: %{
        "id" => 123,
        "name" => "Joe User",
        "email" => "joe@gmail.com",
        "password" => "password1231243",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule Deposit do
    OpenApiSpex.schema(%{
      title: "Deposit",
      description: "An account deposit",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Deposit ID"},
        type: %Schema{type: :string, description: "bank_deposit"},
        value: %Schema{type: :string, description: "100.00"},
        token_card: %Schema{type: :string, description: "TewfGhuuk6HJk54Ghkli"},
        status: %Schema{type: :string, description: "CREATED"},
        note: %Schema{type: :string},
        account_id: %Schema{type: :integer, description: 123},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :email, :password],
      example: %{
        "id" => 123,
        "type" => "bank_deposit",
        "token_card" => "TewfGhuuk6HJk54Ghkli",
        "status" => "CREATED",
        "note" => "test note",
        "value" => "100.00",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule Transfer do
    OpenApiSpex.schema(%{
      title: "Transfer",
      description: "An account transfer",
      type: :object,
      properties: %{
        value: %Schema{type: :string, description: "100.00"},
        status: %Schema{type: :string, description: "CREATED"},
        note: %Schema{type: :string},
        from_account_id: %Schema{type: :integer, description: 123},
        to_account_id: %Schema{type: :integer, description: 123},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :email, :password],
      example: %{
        "id" => 123,
        "status" => "CREATED",
        "note" => "test note",
        "to_account_id" => "321",
        "value" => "100.00",
        "from_account_id" => "123",
        "to_account_id" => "321",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule Payment do
    OpenApiSpex.schema(%{
      title: "Payment",
      description: "An payment value",
      type: :object,
      properties: %{
        value: %Schema{type: :string, description: "100.00"},
        status: %Schema{type: :string, description: "CREATED"},
        note: %Schema{type: :string},
        account_id: %Schema{type: :integer, description: 123},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :email, :password],
      example: %{
        "id" => 123,
        "status" => "CREATED",
        "note" => "test note",
        "account_id" => "321",
        "value" => "100.00",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule Operation do
    OpenApiSpex.schema(%{
      title: "Operation",
      description: "An account operation",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Deposit ID"},
        type: %Schema{type: :string, description: "transfer"},
        value: %Schema{type: :string, description: "100.00"},
        status: %Schema{type: :string, description: "CREATED"},
        note: %Schema{type: :string, description: "Transfer to account_id: 2"},
        account_id: %Schema{type: :integer, description: 123},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:name, :email, :password],
      example: %{
        "id" => 123,
        "type" => "transfer",
        "status" => "CREATED",
        "note" => "Transfer to account_id: 2",
        "value" => "100.00",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule UserRequest do
    OpenApiSpex.schema(%{
      title: "UserRequest",
      description: "POST body for creating a user",
      type: :object,
      properties: %{
        user: %Schema{anyOf: [User]}
      },
      required: [:user],
      example: %{
          "name" => "Joe User",
          "email" => "joe@gmail.com",
          "password" => "password123456"
      }
    })
  end

  defmodule UserResponse do
    OpenApiSpex.schema(%{
      title: "UserResponse",
      description: "Response schema for single user",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        message: "User Authenticated",
        user: %{
          name: "Joe",
          nickname: "joe@email.com",
          token: "SdasdEGgFDVb45582.123FsDFGFeKol.klopqSDxvfBnh"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule UserSigninResponse do
    OpenApiSpex.schema(%{
      title: "UserSigninResponse",
      description: "Response schema for user signin",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        "message" => "User created",
          user: %{
          "id" => 123,
          "name" => "Joe User",
          "email" => "joe@gmail.com",
          account: %{
            "number" => "12312",
            "balance" => "0.00"
          }
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule DepositResponse do
    OpenApiSpex.schema(%{
      title: "DepositResponse",
      description: "Response schema for deposit account",
      type: :object,
      properties: %{
        data: Deposit
      },
      example: %{
        "message" => "User created",
          user: %{
          "id" => 123,
          "name" => "Joe User",
          "email" => "joe@gmail.com",
          account: %{
            "number" => "12312",
            "balance" => "0.00"
          }
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule TransferResponse do
    OpenApiSpex.schema(%{
      title: "TransferResponse",
      description: "Response schema for transfer account",
      type: :object,
      properties: %{
        data: Transfer
      },
      example: %{
        "message" => "Transfer received",
        transfer: %{
          "value" => "100.00",
          "to_account" => "123",
          "from_account" => "321",
          "status" => "CREATED"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule PaymentResponse do
    OpenApiSpex.schema(%{
      title: "PaymentResponse",
      description: "Response schema for payment value",
      type: :object,
      properties: %{
        data: Payment
      },
      example: %{
        message: "Payment received",
        payment: %{
          "value" => "100.00",
          "status" => "CREATED"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule ExtractResponse do
    OpenApiSpex.schema(%{
      title: "ExtractResponse",
      description: "Response schema for account operations",
      type: :object,
      properties: %{
        data: Operation
      },
      example: %{
        balance: "300.00"
        operations: [
          %{
            "type" => "deposit",
            "value" => "100.00",
            "date" => "2017-09-12T12:34:55Z",
          },
          %{
            "type" => "payment",
            "value" => "50.00",
            "date" => "2017-09-13T12:34:55Z",
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end
end
