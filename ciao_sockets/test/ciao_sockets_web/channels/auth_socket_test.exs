defmodule CiaoSocketsWeb.AuthSocketTest do
  use CiaoSocketsWeb.ChannelCase
  import ExUnit.CaptureLog
  alias CiaoSocketsWeb.AuthSocket

  defp generate_token(id, opts \\ []) do
    salt = Keyword.get(opts, :salt, "fancy_salt")
    Phoenix.Token.sign(CiaoSocketsWeb.Endpoint, salt, id)
  end

  describe "connect/3 success" do
    test "can be connected with a valid token" do
      assert {:ok, %Phoenix.Socket{}} =
        connect(AuthSocket, %{"token" => generate_token(1)})
      
      assert {:ok, %Phoenix.Socket{}} =
        connect(AuthSocket, %{"token" => generate_token(9)})
    end
  end

  describe "connect/3 error" do
    test "cannot be connected to with an invalid salt" do
      params = %{"token" => generate_token(1, salt: "invalid")}
      assert capture_log(fn ->
        assert :error = connect(AuthSocket, params)
      end) =~ "[error] #{AuthSocket} connect error :invalid"
    end
  end

end
