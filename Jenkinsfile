pipeline {
  agent any
  stages {
    stage('Git Poll') {
      steps {
        git(poll: true, url: 'https://github.com/jed-frey/build_caffe2.git')
      }
    }
    stage('Update Git Submodules') {
      steps {
        sh 'git submodule update --init --jobs=6'
        sh 'git submodule foreach "git submodule update --init"'
      }
    }
    stage('Build pybind11') {
      steps {
        sh ''
      }
    }
  }
}c
