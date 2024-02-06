Mox.defmock(EWalletService.RiskCheck.ClientMock, for: EWalletService.RiskCheck.ClientBehaviour)
Application.put_env(:e_wallet_service, :risk_check_client, EWalletService.RiskCheck.ClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EWalletService.Repo, :manual)
