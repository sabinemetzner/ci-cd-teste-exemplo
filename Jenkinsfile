def runCommand(String command) {
  if (isUnix()) {
    sh command
  } else {
    bat command
  }
}

pipeline {
  agent any

  triggers {
    pollSCM('H/5 * * * *')
  }

  options {
    disableConcurrentBuilds()
    timestamps()
  }

  stages {
    stage('Preparacao do ambiente') {
      steps {
        echo 'Verificando as ferramentas do agente Jenkins'
        script {
          runCommand('node --version')
          runCommand('npm --version')
        }
      }
    }

    stage('Instalacao das dependencias') {
      steps {
        script {
          runCommand('npm ci')
        }
      }
    }

    stage('Execucao dos testes automatizados') {
      steps {
        script {
          runCommand('npm test')
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'allure-results/**', allowEmptyArchive: true
    }
  }
}