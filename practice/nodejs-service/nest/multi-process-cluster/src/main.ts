/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-14 18:23:21
 */

/* eslint-disable no-console */
import * as cluster_ from 'node:cluster'
import * as os from 'node:os'
import * as path from 'node:path'
import { NestFactory } from '@nestjs/core'

import { AppModule } from './app.module'

type Cluster = typeof cluster_.default
const cluster = cluster_ as unknown as Cluster

;(async (): Promise<void> => {
  if (cluster.isPrimary) {
    const numCPUs = os.cpus().length

    console.log(`Master is running. ${process.pid}`)

    // 创建工作进程
    for (let i = 0; i < numCPUs; i += 1) {
      cluster.fork()
    }

    cluster.on('online', (worker) => {
      console.log(`Worker ${worker.process.pid} is online`)
    })
    cluster.on('exit', (worker) => {
      console.log(`worker ${worker.process.pid} died`)
    })
  } else {
    const app = await NestFactory.create(AppModule)

    app.getHttpAdapter().useStaticAssets(path.resolve(__dirname, '../', 'public'))

    await app.listen(3003)
    console.log(`Worker ${process.pid} started`)
  }
})()
