import { Injectable, LoggerService } from '@nestjs/common'
import { type Configuration, Logger, configure } from 'log4js'

const defaultLog4jsOptions: Configuration = {
  appenders: {
    stdout: {
      type: 'stdout',
      layout: {
        type: 'pattern',
        pattern: '[A4] %-6z - %d{yyyy-MM-dd hh:mm:ss} %7p [%14.14x{name}] %m',
        tokens: {
          name: (logEvent) => {
            return (logEvent.context && logEvent.context.name) || '-'
          },
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
export class A4Log4jsLogger implements LoggerService {
  private readonly _logger: Logger = logger

  public constructor() {}

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

  public static getTimestamp(): string {
    const localeStringOptions = {
      year: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric',
      day: '2-digit',
      month: '2-digit',
    } as const
    return new Date(Date.now()).toLocaleString(undefined, localeStringOptions)
  }

  public getTimestamp(): string {
    return A4Log4jsLogger.getTimestamp()
  }
}
