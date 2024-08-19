// window.documentDomainReceive = function (e) {
//   window.receiveMsg(e.data)
// }

window.toParentMsg = function (sendMsg) {
  console.log('toParentMsg')
  window.parent.receiveMsgFromParent(sendMsg)
}
