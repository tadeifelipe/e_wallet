defmodule EWalletService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EWalletServiceWeb.Telemetry,
      EWalletService.Repo,
      {DNSCluster, query: Application.get_env(:e_wallet_service, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EWalletService.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EWalletService.Finch},
      # Start a worker by calling: EWalletService.Worker.start_link(arg)
      # {EWalletService.Worker, arg},
      # Start to serve requests, typically the last entry
      EWalletServiceWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EWalletService.Supervisor]

    case Application.get_env(:e_wallet_service, EWalletServiceWeb.Kafka.Producer)[:enabled] do
      true ->
        Supervisor.start_link(
          [
            %{
              id: EWalletServiceWeb.Kafka.Producer,
              start: {EWalletServiceWeb.Kafka.Producer, :start_link, []}
            }
            | children
          ],
          opts
        )

      false ->
        Supervisor.start_link(children, opts)
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EWalletServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
