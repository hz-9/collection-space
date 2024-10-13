export interface Service {
  name: string
  baseUrl: string
}

export enum ServiceStatus {
  init,
  loading,
  success,
  error,
}

export interface Website {
  name: string
  baseUrl: string
}

export interface MessageLog {
  type: 'send' | 'receive'
  msg: string
}

export interface SendInfo {
  type: 'msg' | 'callback'
  msg: string
}
