/**
 * @Author       : Chen Zhen
 * @Date         : 2024-06-30 23:33:49
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 18:10:36
 */
import { ConsoleLogger, Injectable, LogLevel } from '@nestjs/common';

@Injectable()
export class MyConsoleLogger extends ConsoleLogger {
  protected formatPid(pid: number): string {
    return `[HZ-9] ${pid}  - `;
  }

  protected formatMessage(
    logLevel: LogLevel,
    message: unknown,
    pidMessage: string,
    formattedLogLevel: string,
    contextMessage: string,
    timestampDiff: string,
  ) {
    const msg = super.formatMessage(
      logLevel,
      message,
      pidMessage,
      formattedLogLevel,
      contextMessage,
      timestampDiff,
    );

    return `${msg}`;
  }
}
