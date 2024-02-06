defmodule EWalletServiceWeb.ErrorJSON do
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def error(%{changeset: changeset}) do
    %{message: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)}
  end

  def error(%{msg: :email_already_exists}) do
    %{message: "E-mail already exists"}
  end

  def error(%{msg: :email_or_password_invalid}) do
    %{message: "E-mail or password invalid"}
  end

  def error(%{msg: :bad_request}) do
    %{message: "Somenthing went wrong"}
  end

  def error(%{status: status}) do
    %{status: status}
  end

  defp translate_errors({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
