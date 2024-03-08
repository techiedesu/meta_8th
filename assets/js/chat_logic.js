
const initChat = (chatChannel) => {
    const chatRoot = document.querySelector(".chat-root")
    console.log(chatRoot)

    if (chatRoot === null)
        return

    if (chatChannel.state === "joined")
        return

    const messageInput = chatRoot.querySelector(".message-input")
    const sendButton = chatRoot.querySelector(".send-message")

    chatChannel.on("shout", resp => {
        console.info("чят", resp)
    })

    sendButton.addEventListener("click", () => {
        const text = messageInput.value
        chatChannel.push("shout", { text: text })
    })

    window.messageInput = messageInput
    window.sendButton = sendButton
}

export default initChat
