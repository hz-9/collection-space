/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-08 01:05:25
 */
import { Injectable } from '@nestjs/common'

@Injectable()
export class AppService {
  getHello(): string {
    return 'This is the nest service.'
  }
}
