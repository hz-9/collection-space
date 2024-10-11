/**
 * @Author       : Chen Zhen
 * @Date         : 2024-06-30 23:33:49
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-11 01:13:35
 */
import { ConsoleLogger as NestjsConsoleLogger, Injectable } from '@nestjs/common'

@Injectable()
export class ConsoleLogger extends NestjsConsoleLogger {
  protected formatPid(pid: number): string {
    return `[HZ-9] ${pid.toString().padEnd(6, ' ')} - `
  }

  protected getTimestamp(): string {
    const timestamp = new Date(Date.now()).toLocaleString(undefined, {
      year: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric',
      day: '2-digit',
      month: '2-digit',
    })
    return timestamp.replace(/\//g, '-')
  }

  protected formatContext(context: string): string {
    if (context.length > 14) return super.formatContext(context.substring(0, 14))
    return super.formatContext(context.padStart(14, ' '))
  }
}
