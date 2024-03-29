defmodule EWalletService.RiskCheck.ClientTest do
  use ExUnit.Case

  alias EWalletService.RiskCheck.Client

  setup do
    bypass = Bypass.open()

    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "should verify risk successfully", %{bypass: bypass} do
      body_resp = ~s({
        "status": "Approved"
      })

      Bypass.expect(bypass, "POST", "/", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body_resp)
      end)

      assert {:ok,
              %{
                status: "Approved"
              }} =
               bypass.port
               |> endpoint_url()
               |> Client.call()
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
