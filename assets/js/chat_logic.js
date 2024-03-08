
const initChat = (chatChannel) => {
    const chatRoot = document.querySelector(".chat-root")
    console.log(chatRoot)

    if (chatRoot === null)
        return

    if (chatChannel.state === "joined")
        return

    const messageInput = chatRoot.querySelector(".message-input")
    const sendButton = chatRoot.querySelector(".send-message")

    const history = chatRoot.querySelector(".history")
    chatChannel.on("shout", resp => {
        const line = document.createElement("p")

        const messageDateTime =
            new Date(resp.timestamp)
                .toLocaleString()
        const formattedMessage =
            document
                .createTextNode(`[${messageDateTime}] ${resp.nickname}: ${resp.text}`)
        line.appendChild(formattedMessage)

        history.append(line)
    })

    sendButton.addEventListener("click", () => {
        const text = messageInput.value
        chatChannel.push("shout", { text: text })
    })

    window.messageInput = messageInput
    window.sendButton = sendButton
}

export default initChat
