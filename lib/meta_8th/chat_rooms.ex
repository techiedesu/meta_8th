defmodule Meta8th.ChatRooms do
  alias Meta8th.Redix

  def get_public_chat_rooms() do
    Redix.command(["KEYS", "META8TH.CHATS.PUBLIC.*"])
  end
end
