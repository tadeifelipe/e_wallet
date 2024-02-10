defmodule EWalletConsumer.Repo do
  use Ecto.Repo,
    otp_app: :e_wallet_consumer,
    adapter: Ecto.Adapters.Postgres
end
