# EWallet

![](https://github.com/tadeifelipe/e_wallet/actions/workflows/elixir.yaml/badge.svg)

API to manage a digital wallet

# Application Architecture

API made by **Elixir** with **Phoenix Framework**, using **REST** patterns. 

Using **PostgreSQL** for data persistence and **Kafka** to send messages between services.

> The service will start at **4000** port, and it is necessarya kafka running at **9092** port.
Were add docker images in `docker-compose.yml` to simulate the database and kafka.




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
