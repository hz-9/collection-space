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
  
  // 应保证所有仓库使用一个部署私钥
  def REPO_CREDENTIALSID = '{{ repo.credentialsId }}'

  def DOCKER_IMAGES_WEBSITE = 'cypress/base:12'
  def DOCKER_PARAMS_WEBSITE = '-v /root/.cache/Cypress:/root/.cache/Cypress -v /root/.npmrc:/root/.npmrc'

  def DOCKER_IMAGES_SERVICE = 'node:12'
  def DOCKER_PARAMS_SERVICE = '-v /root/.cache/Cypress:/root/.cache/Cypress -v /root/.npmrc:/root/.npmrc'

  def WEBSITE_LIST = [
      // [ name: 'website-1',  git: 'git@gitee.com:heavenzhen999/website-1.git', baseUrl: '/web' ],
  ]

  def WEBSITE_NUM = 1

  def SERVICE_LIST = [
      // [ name: 'service-user-center',  git: 'git@gitee.com:heavenzhen999/service-user-center.git' ],
  ]

  def SERVICE_NUM = 1

  def TIMESTAP = createVersion()
  def PACKAGE_NAME = "package-${TIMESTAP}"

  stage('Init') {
    sh 'rm -rf ./package.*'
    sh "mkdir -p ${PACKAGE_NAME}/website"
    sh "mkdir -p ${PACKAGE_NAME}/service"

    for (Object WEBSITE: WEBSITE_LIST) {
      sh "Website ${WEBSITE.name}. Git: ${WEBSITE.git}"
    }

    for (Object SERVICE: SERVICE_LIST) {
      sh "Service ${SERVICE.name}. Git: ${SERVICE.git}"
    }
  }

    docker.image('node:10.15.3').inside('-v /root/.npmrc:/root/.npmrc') {
        stage('Website Init') {
            sh 'node -v'
            sh 'npm -v'
            sh 'cat /root/.npmrc'

            sh 'rm -rf ./Website-new'
            sh 'mkdir -p ./Website-new'
            sh 'rm -rf ./rss-platform.*.tar.gz'
        }

        stage('Website Portal') {
            dir("Website/web") {
                // 'master'
                git branch: 'master', credentialsId: 'XXXX', url: 'xxx.git'

                // sh 'rm -rf package-lock.json'
                sh 'rm -rf .eslintignore'
                sh 'rm -rf .eslintrc'
                sh 'ls'

                sh 'npm i'

                sh 'npm run build'

                sh 'cp -r ./dist/web ../../Website-new'
            }
        }
    }

    docker.image("${DOCKER_IMAGES_WEBSITE}").inside("${DOCKER_PARAMS_WEBSITE}") {
        def websiteTasks = [:]

        for (Object WEBSITE: WEBSITE_LIST) {
            websiteTasks["${WEBSITE.name}"] = websiteTask(WEBSITE)

            if (websiteTasks.size() == WEBSITE_NUM) {
                parallel websiteTasks
                websiteTasks = [:]
            }
        }

        if (websiteTasks.size() > 0) {
            parallel websiteTasks
        }
    }

    docker.image("${DOCKER_IMAGES_SERVICE}").inside("${DOCKER_PARAMS_SERVICE}") {
        def serviceTasks = [:]

        for (Object SERVICE: SERVICE_LIST) {
            serviceTasks["${SERVICE.name}"] = serviceTask(SERVICE)

            if (serviceTasks.size() == 3) { // 共有 6 各服务，3 + 3 的组合更好
                parallel serviceTasks
                serviceTasks = [:]
            }
        }

        if (serviceTasks.size() > 0) {
            parallel serviceTasks
        }
    }

    stage('Export Package') {
        sh "tar zcvf ${PACKAGE_NAME}.tar.gz        ./${PACKAGE_NAME}"
    }

    stage('Archive') {
        archiveArtifacts artifacts: "${PACKAGE_NAME}.tar.gz", onlyIfSuccessful: true
    }

    stage('Clean') {
        sh "rm -rf  ${PACKAGE_NAME}.tar.gz"
    }
}

def websiteTask(Object WEBSITE) {
    return {
      dir("website/${SERVER.name}") {
        stage("Website ${WEBSITE.name} pull repo") {
          git branch: 'master', credentialsId: "${REPO_CREDENTIALSID}", url: "${WEBSITE.git}"
        }

        stage("Website ${WEBSITE.name} install node_modules") {
          sh 'npm install'
        }

        stage("Website ${WEBSITE.name} build") {
          sh 'npm run build'
        }
      }

      stage("Website ${WEBSITE.name} move dist") {
        sh "cp -r website/${SERVER.name}/dist${VUE_BASE_URL} ${PACKAGE_NAME}/website${VUE_BASE_URL}"
      }
    }
}

def serviceTask(Object SERVICE) {
    return {
      dir("service/${SERVICE.name}") {
        stage("Service ${SERVICE.name} pull repo") {
          git branch: 'master', credentialsId: "${REPO_CREDENTIALSID}", url: "${SERVICE.git}"
        }

        stage("Service ${SERVICE.name} install node_modules") {
          sh 'npm install'
        }

        stage("Service ${SERVICE.name} build") {
          sh 'npm run build'
        }
      }

      stage("Service ${SERVICE.name} move dist") {
        sh "cp -r service/${SERVICE.name} ${PACKAGE_NAME}/service/${VUE_BASE_URL}"
      }
    }
}
