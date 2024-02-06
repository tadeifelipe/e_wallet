defmodule EWalletService.RiskCheck.ClientBehaviour do
  @callback call() :: {:error, :map} | {:ok, :atom}
end
