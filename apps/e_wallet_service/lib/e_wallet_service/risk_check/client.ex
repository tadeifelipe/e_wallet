defmodule EWalletService.RiskCheck.Client do
  use Tesla

  @default_url "https://ewallet-risk-check.free.beeceptor.com"

  def call(url \\ @default_url) do
    url
    |> post("")
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    {:error, :bad_request}
  end

  defp handle_response({:error, _}) do
    {:error, :internal_server_error}
  end
end
