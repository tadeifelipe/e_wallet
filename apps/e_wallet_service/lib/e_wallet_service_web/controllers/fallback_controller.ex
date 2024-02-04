defmodule EWalletServiceWeb.FallbackController do
  use EWalletServiceWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: EWalletServiceWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end
end
