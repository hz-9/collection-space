/**
 * @Author       : Chen Zhen
 * @Date         : 2024-06-30 23:33:49
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-11 01:18:13
 */
import { ConsoleLogger as NestjsConsoleLogger, Injectable } from '@nestjs/common'

import { type Configuration, Logger, configure } from 'log4js'

const defaultLog4jsOptions: Configuration = {
  appenders: {
    stdout: {
      type: 'stdout',
      layout: {
        type: 'pattern',
        pattern: '[HZ-9] %-6z - %d{yyyy-MM-dd hh:mm:ss} %7p [%14.14x{name}] %m',
        tokens: {
          name: (logEvent) => (logEvent.context && logEvent.context.name) || '-',
        },
      },
    },
  },

  categories: {
    default: {
      appenders: ['stdout'],
      level: 'INFO',
    },
  },
}

const logger = configure(defaultLog4jsOptions).getLogger()

@Injectable()
export class Log4jsLogger extends NestjsConsoleLogger {
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

  private readonly _logger: Logger = logger

  public updateContext(context?: string): void {
    if (context && context.length > 0) {
      this._logger.addContext('name', context)
    } else {
      this._logger.addContext('name', '')
    }
  }

  public verbose(message: unknown, context?: string): void {
    this.updateContext(context)
    this._logger.trace(message)
  }

  public debug(message: unknown, context?: string): void {
    this.updateContext(context)
    this._logger.debug(message)
  }

  public log(message: unknown, context?: string): void {
    this.updateContext(context)
    this._logger.info(message)
  }

  public warn(message: unknown, context?: string): void {
    this.updateContext(context)
    this._logger.warn(message)
  }

  public error(message: unknown, trace?: string, context?: string): void {
    this.updateContext(context)
    this._logger.error(message, trace)
  }
}
