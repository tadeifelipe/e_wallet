# EWallet

![](https://github.com/tadeifelipe/e_wallet/actions/workflows/elixir.yaml/badge.svg)

API to manage a digital wallet


Bellow is the System Design
[System design](https://excalidraw.com/#json=WMk2XMzZQmOG9JqKe4Y3p,_9yPBSvyxUj3UW_tiFT4Qg)

# Application Architecture

API made by **Elixir** with **Phoenix Framework**, using **REST** patterns. 

Using **PostgreSQL** for data persistence and **Kafka** to send messages between services.

The app uses a Umbrella project focusing in scalability and low coupling, enabling separate builds

The first app uses a Phoenix REST API offering an API and sending messages to a topic kafka

The second one handle with this messages and execute the specific operations solicited, changing the balance account

```
 ╭┄┄┄┄┄┄┄╮      ┌──────────┐      ┌──────────┐     ┌──────────┐
 ┆       ┆  ←→  │   API    |  ←→  |          │ ←→  │          |
 ┆  Web  ┆ HTTP │  EWallet │      │ Kafka    │     │ EWallet  │ 
 ╰┄┄┄┄┄┄┄╯      │  Service │      └──────────┘     │ Consumer │ 
                └──────────┘                       └──────────┘ 
```


> The service will start at **4000** port, and it is necessary kafka running at **9092** port.
The were add docker images in `docker-compose.yml` to simulate the database and kafka.



```
 ╭┄┄┄┄┄┄┄╮      ┌──────────┐      ┌──────────┐ 
 ┆       ┆  ←→  │          |  ←→  |          │ 
 ┆  Web  ┆ HTTP │ EWallet  │      │ Postgres │      
 ╰┄┄┄┄┄┄┄╯      │  Service │      └──────────┘      
                └──────────┘
                     ↑ JSON/HTTP
                     ↓
                ┌──────────┐    
                │          │    
                │Risk Check│      
                │ Service  │      
                └──────────┘      
```

# Get Started

Prerequisite technologies
+ [Elixir](https://elixir-lang.org/)
+ [Docker](https://www.docker.com/products/docker-hub/)
+ [Docker-compose](https://docs.docker.com/compose/)


### - Docker
```
$ docker-compose up
```

### - Setup
```
Starting cloning the repository with `https://github.com/tadeifelipe/e_wallet`

Fill in connection data with Postgres at: /config/dev.exs and /config/test.exs

$ mix deps.get       Install dependencies
$ mix ecto.create    Create database
$ mix ecto.migrate   Create migrations
$ mix test           Run tests
$ mix test --cover   Test coverage
$ mix phx.server     Run api server
```
### - Swagger
In orden to visualize the applications endpoints, it's provided a swagger-ui url `http://http://localhost:4000/swaggerui`

# Authorization

The app uses Basic Authentication, e by default, gets the user and password via:

### - Create User
```
 curl -X POST \
 http://localhost:4000/api/v1/users \
 -H 'Content-Type: application/json' \
 -H 'cache-control: no-cache' \
 -d '{
    "name": "Teste",
    "password": "123456",
    "email": "teste@gmail.com"
 }'
```
#### response
```
{
    "message": "User created",
    "user": {
        "id": "1",
        "name": "Teste",
        "email": "teste@gmail.com",
         "account": {
            "balance": "0.00",
            "number": "77"
        }
    }
}
```


### SignIn
```
 curl -X POST \
 http://localhost:4000/api/signin \
 -H 'Content-Type: application/json' \
 -H 'cache-control: no-cache' \
 -d '{
    "email": "teste@gmail.com",
    "password": "123456"
}'
```
#### response
```
{
     "user": {
          "name": "Teste",
          "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJlbGl4aXJiYW5rX3dlYiIsImV4cCI6MTYyMzQzNzcyMSwiaWF0IjoxNjIxMDE4NTIxLCJpc3MiOiJlbGl4aXJiYW5rX3dlYiIsImp0aSI6IjUyNmZjMjAwLWVlYjMtNDQwMC1hNTIxLWU3MDJmZmYxN2MxMSIsIm5iZiI6MTYyMTAxODUyMCwic3ViIjoiYmRhYzk1NjAtMjQxYy00MmU2LWI2NzItN2QzZmU2Yzg3ZTA2IiwidHlwIjoiYWNjZXNzIn0.ayqUlRdjfRBBZMcOsIan6s90bCkCZhTNACcRzlf5edIVNwJSj2F_khAW2S6t7lEoE6j7G1KHfXR60NH8GJsJ1g"
     },
    "message": "User Authenticated"
}
``` 

# Services

### - Deposit
```
 curl -X POST \
 http://localhost:4000/api/v1/accounts/deposit \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
 -d '{
    "value": "700.00",
    "type": "bank_deposit" <- or credit_card_deposit and token_card propery
}'
```
#### response
```
{
    "message": "Deposit received",
    "deposit": {
        "value": "700.00",
        "type": "bank_deposit",
        "status": "CREATED"
    }
}
```

### - Payment
```
 curl -X POST \
 http://localhost:4000/api/v1/payments \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
 -d '{
    "value": "100.00"
}'
```
#### response
```
{
    "message": "Payment received",
    "payment": {
        "value": "100.00",
        "status": "CREATED"
    }
}
```

### - Transfer
```
 curl -X POST \
 http://localhost:4000/api/v1/accounts/transfer \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
 -d '{
    "value": "100.00",
    "to_account_id: "56"
}'
```
#### response
```
{
    "message": "Transfer received",
    "transfer": {
        "value": "100.00",
        "status": "CREATED",
        "to_account": "56",
        "from_account: "10"
    }
}
```

### - Extract
```
 curl -X GET \
 http://localhost:4000/api/v1/accounts/extract \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
```
#### response
```
{
	"balance": "300.00",
	"operations": [
		{
			"value": "80.00",
			"type": "payment",
			"inserted_at": "2024-02-13T14:13:23"
		},
		{
			"value": "50.00",
			"type": "deposit",
			"inserted_at": "2024-02-13T14:09:24"
		},
		{
			"value": "110.00",
			"type": "deposit",
			"inserted_at": "2024-02-13T14:07:06"
		}
	]
}
```

# Technologies
+ **pbkdf2_elixir** for password hashes
+ **tesla** for client HTTP
+ **brod** and **broadway_kafka** for client Kafka
+ **mox** for lib mock services
+ **bypass** stub services http for integration tests
+ **testcontainers** lib for simulate kafka container in integration tests
+ **open_api_spex** for app specification and swagger-ui
+ **excoveralls** for coverage test
