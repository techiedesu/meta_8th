import { Socket } from "phoenix"
const socket = new Socket("/socket", { params: { token: window.userToken } })
socket.connect()

const channel = socket.channel("chat_room:signaling", { token: window.userToken })

if (window.userToken !== undefined && window.userToken !== null) {
  const push = channel.join()

  push.receive("ok", resp => {
    console.info("соединение с комнатой установлено", resp)
  })

  push.receive("error", resp => {
    console.error("соединение с комнатой нее удалось установить. разрываем соединение", resp)
    channel.leave()
  })
}

export default channel
