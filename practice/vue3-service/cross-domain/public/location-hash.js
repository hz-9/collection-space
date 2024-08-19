window.callbackPort = ''
window.onhashchange = function () {
  if (location.hash !== '') {
    const hashStr = location.hash.replace(/^#/, '')
    location.hash = ''
    if (/^callback-/.test(hashStr)) {
      window.callbackPort = hashStr.replace(/^callback-/, '')
      window.receiveMsg(JSON.stringify({ type: 'callback' }))
    } else if (/^msg-/.test(hashStr)) {
      window.receiveMsg(
        JSON.stringify({ type: 'msg', msg: decodeURIComponent(hashStr.replace(/^msg-/, '')) })
      )
    }
  }
}
