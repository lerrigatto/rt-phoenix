defmodule CiaoSocketsWeb.UserSocketTest do
  use CiaoSocketsWeb.ChannelCase
  alias CiaoSocketsWeb.UserSocket

  describe "connect/3" do
    test "can be connectect without parameters" do
      assert {:ok, %Phoenix.Socket{}} = connect(UserSocket, %{})
    end
  end

  describe "id/1" do
    test "an identifier is not provided" do
      assert {:ok, socket} = connect(UserSocket, %{})
      assert UserSocket.id(socket) == nil
    end
  end
end
