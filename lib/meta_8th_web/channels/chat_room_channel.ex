defmodule Meta8thWeb.ChatRoomChannel do
  require Logger

  use Meta8thWeb, :channel

  alias Meta8th.Accounts

  defmodule MsgPayload do
    @enforce_keys [:text]
    defstruct text: nil

    @type t() :: %__MODULE__{
            text: String.t()
          }
  end

  @impl true
  def join("chat_room:signaling", %{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token) do
      {:error, reason} ->
        Logger.error("chat_room:signaling", reason: reason)
        {:error, %{reason: "unauthorized"}}

      {:ok, _} ->
        {:ok, socket}
    end
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("shout", %{"text" => text}, socket) do
    case(Accounts.get_user!(socket.assigns.user)) do
      Ecto.NoResultsError ->
        {:noreply, socket}

      %{nickname: nickname} ->
        broadcast(socket, "shout", %{
          text: text,
          nickname: nickname,
          timestamp: :os.system_time(:millisecond)
        })

        {:noreply, socket}
    end
  end
end
