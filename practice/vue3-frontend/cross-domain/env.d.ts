/// <reference types="vite/client" />

interface Window {
  receiveMsg?: (msg: any) => void

  syncName?: () => void

  receiveMsgFromParent?: (msg: any) => void
}
