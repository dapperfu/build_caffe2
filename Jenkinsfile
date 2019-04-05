pipeline {
  agent any
  stages {
    stage('Git') {
      steps {
        sh '''git submodule update --init --jobs=8
git submodule foreach git submodule update --init --jobs=8
git submodule foreach git submodule update --init --jobs=8
'''
      }
    }
  }
}