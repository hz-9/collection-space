const msgList = []

window.syncMsgList = function () {
  const reverseMsgList = [...msgList]
  reverseMsgList.reverse()
  if (reverseMsgList.length > 8) reverseMsgList.length = 8

  let msgListEl = document.getElementById('msg-list')
  if (!msgListEl) {
    msgListEl = document.createElement('ul')
    msgListEl.id = 'msg-list'
    document.body.appendChild(msgListEl)
  }

  if (reverseMsgList.length) {
    msgListEl.innerHTML = reverseMsgList.map((msg) => `<li>${msg.type}: ${msg.msg}</li>`).join('')
  } else {
    msgListEl.innerHTML = '<li>Please click the button to send message.</li>'
  }
}

window.onload = function () {
  window.syncMsgList()
}

window.receiveMsg = function (msgData) {
  try {
    const { type, msg } = JSON.parse(msgData)
    switch (type) {
      case 'msg':
        msgList.push({ type: 'receive', msg })
        window.syncMsgList()
        break
      case 'callback': {
        const sendMsg = `This is ${window.from ?? 'iframe'}, send to ${window.to ?? 'parent'}: ${new Date().toLocaleString()}`
        msgList.push({ type: 'send', msg: sendMsg })
        window.toParentMsg({ type: 'msg', msg: sendMsg })
        window.syncMsgList()
        break
      }
      default:
        break
    }
  } catch (error) {
    console.error('Parser error:', error)
  }
}
