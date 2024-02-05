defmodule EWalletServiceWeb.FallbackController do
  use EWalletServiceWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: EWalletServiceWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :email_already_exists}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: EWalletServiceWeb.ErrorJSON)
    |> render(:error, msg: :email_already_exists)
  end

  def call(conn, {:error, :email_or_password_invalid}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: EWalletServiceWeb.ErrorJSON)
    |> render(:error, msg: :email_or_password_invalid)
  end
end
