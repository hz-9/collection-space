// 获取时间戳
def getTime() {
    return new Date().format('yyyyMMddHHmmss')
}

node {
  properties([
    [ $class: 'JiraProjectProperty' ],

    buildDiscarder(
      logRotator(
        artifactDaysToKeepStr: '3',
        artifactNumToKeepStr: '3',
        daysToKeepStr: '3',
        numToKeepStr: '3'
      )
    )
  ])

  // 已配置的部署私钥
  def REPO_CREDENTIALSID = '{{ repo.credentialsId }}'

  // 源码拉取地址，应使用 SSH 格式，且必须配置部署私钥
  def REPO_SSH_URL = '{{ repo.sshUrl }}' 

  // 源码拉取分支
  def REPO_BRANCH = 'master'
  // def REPO_BRANCH = env.BRANCH_NAME // 如果为多分支流水线，则使用 env.BRANCH_NAME

  // 打包环境，镜像名称，安装、打包操作必须要 Node.js 环境中运行
  def DOCKER_IMAGES = 'node:12'
  // 镜像启动时传入的参数
  def DOCKER_PARAMS = '-v /root/.npmrc:/root/.npmrc'

  // 服务名称
  def SERVICE_NAME = 'service-system'

  // 打包文件名
  def TIMESTAP = createVersion()
  def PACKAGE_NAME = "${SERVICE_NAME}.${TIMESTAP}"

  docker.image("${DOCKER_IMAGES}").inside("${DOCKER_PARAMS}") {
    stage('Print version') {
        sh 'node -v'
        sh 'npm -v'
    }

    dir("workspace") {
      stage('Pull repo') {
        git branch: "${REPO_BRANCH}", credentialsId: "${REPO_CREDENTIALSID}", url: "${REPO_SSH_URL}"
      }

      stage('Install node_modules') {
        sh 'npm install'
      }

      stage('Build from TypeScript') {
        sh 'npm run build'
      }
    }
  }

  // 对打包成果进行压缩便于文件归档，以及发布
  stage('Export Package') {
      sh 'rm -rf ./package.*'
      sh "mkdir  ./package.${TIMESTAP}"

      sh "cp -r    workspace/dist         ./package.${TIMESTAP}"
      sh "cp       workspace/pacakge.json ./package.${TIMESTAP}"
      sh "cp       workspace/process.yml  ./package.${TIMESTAP}"
      
      sh "tar zcvf ${PACKAGE_NAME}.tar.gz ./package.${TIMESTAP}"
  }

  stage('Archive') {
      archiveArtifacts artifacts: "${PACKAGE_NAME}.tar.gz", onlyIfSuccessful: true
  }

  stage('Clean .tar.gz') {
    sh "rm -rf ${PACKAGE_NAME}.tar.gz"
  }
}