/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 11:58:57
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 12:02:04
 */
import { AccessLevel, Inject, SingletonProto } from '@eggjs/tegg'
import { EggLogger } from 'egg'

@SingletonProto({
  // 如果需要在上层使用，需要把 accessLevel 显示声明为 public
  accessLevel: AccessLevel.PUBLIC,
})
export class HelloService {
  // 注入一个 logger
  @Inject()
  logger: EggLogger

  // 封装业务
  async hello(userId: string): Promise<string> {
    const result = { userId, handledBy: 'foo module' }
    this.logger.info('[hello] get result: %j', result)
    return `hello, ${result.userId}`
  }
}
