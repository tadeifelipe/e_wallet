defmodule EWalletServiceWeb.Plugs.AuthAccessPipeline do
  import Plug.Conn

  def init(ops), do: ops

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- EWalletServiceWeb.Token.verify(token) do
      assign(conn, :user_id, data.user_id)
    else
      _error ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_format(:json)
        |> Phoenix.Controller.put_view(json: EWalletServiceWeb.ErrorJSON)
        |> Phoenix.Controller.render(:error, status: :unauthorized)
        |> halt()
    end
  end
end
