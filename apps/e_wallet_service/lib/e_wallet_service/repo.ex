defmodule EWalletService.Repo do
  use Ecto.Repo,
    otp_app: :e_wallet_service,
    adapter: Ecto.Adapters.Postgres
end
