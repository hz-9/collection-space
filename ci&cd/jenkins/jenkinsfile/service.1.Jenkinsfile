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
    }
  }

  // 对打包成果进行压缩便于文件归档，以及发布
  stage('Export Package') {
      sh 'rm -rf ./package.*'

      sh "cp -r    workspace              ./package.${TIMESTAP}"
      
      sh "tar zcvf ${PACKAGE_NAME}.tar.gz ./package.${TIMESTAP}"
  }

  stage('Archive') {
      archiveArtifacts artifacts: "${PACKAGE_NAME}.tar.gz", onlyIfSuccessful: true
  }

  // 服务器部署名称
  def SERVER_NAME =[
    "service-01",
    "service-02",
    "service-03",
  ]

  // 服务器部署路径
  def PUBLISH_PATH = '/usr/${项目名称}/platform'

  // TODO 应修改为覆盖操作
  // 部署脚本
  def PUSH_COMMAND = """
cd ${PUBLISH_PATH}

tar zxvf ${PACKAGE_NAME}.tar.gz
rm -rf   ${PACKAGE_NAME}.tar.gz

if [ -d "./service/${SERVICE_NAME}" ] ;then

  cd "./service/${SERVICE_NAME}"

  pm2 stop process.yml

  rm -rf   ./*

  cd ../../

else

  mkdir -p "./service/${SERVICE_NAME}"

fi

mv       ./package.${TIMESTAP}/*   ./service/${SERVICE_NAME}

cd "./service/${SERVICE_NAME}"

pm2 start process.yml

cd ../../

rm -rf   ./package.${TIMESTAP}
  """

  for (String SERVER_NAME: SERVER_NAME_ARR) {
    stage("Publish -> ${SERVER_NAME}") {
      sshPublisher(
        publishers: [
          sshPublisherDesc(
            configName: "${SERVER_NAME}",
            transfers: [
              sshTransfer(
                excludes: '',
                execCommand: "${PUSH_COMMAND}",
                execTimeout: 120000,
                flatten: false,
                makeEmptyDirs: true,
                noDefaultExcludes: false,
                patternSeparator: '[, ]+',
                remoteDirectory: "${PUBLISH_PATH}",
                remoteDirectorySDF: false,
                removePrefix: '',
                sourceFiles: "${PACKAGE_NAME}.tar.gz"
              )
            ],
            usePromotionTimestamp: false,
            useWorkspaceInPromotion: false,
            verbose: true
          )
        ]
      )
    }
  }

  stage('Clean .tar.gz') {
    sh "rm -rf ${PACKAGE_NAME}.tar.gz"
  }
}