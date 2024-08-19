window.onmessage = function (e) {
  window.receiveMsg(e.data)
}

window.toParentMsg = function (sendMsg) {
  window.parent.postMessage(JSON.stringify(sendMsg), '*')
}
