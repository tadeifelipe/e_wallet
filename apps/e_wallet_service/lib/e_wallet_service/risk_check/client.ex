defmodule EWalletService.RiskCheck.Client do
  use Tesla
  alias EWalletService.RiskCheck.ClientBehaviour

  require Logger

  @default_url "https://ewallet-risk-check.free.beeceptor.com"

  @behaviour ClientBehaviour

  @impl ClientBehaviour
  def call(url \\ @default_url) do
    Logger.info("Checking operation's risk")

    url
    |> post("")
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    response = Jason.decode!(body)
    {:ok, %{status: Map.get(response, "status")}}
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    {:error, :bad_request}
  end

  defp handle_response({:error, _}) do
    {:error, :internal_server_error}
  end
end
