const cluster = require('cluster')
const os = require('os')

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
  // eslint-disable-next-line global-require
  require('./app')
}
