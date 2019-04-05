pipeline {
  agent any
  stages {
    stage('Git') {
      parallel {
        stage('Git') {
          steps {
            sh '''git submodule update --init --jobs=8
git submodule foreach git submodule update --init --jobs=8
git submodule foreach git submodule update --init --jobs=8
'''
          }
        }
        stage('Git Remote Poll') {
          steps {
            git(url: 'https://github.com/jed-frey/build_caffe2.git', poll: true, changelog: true)
          }
        }
      }
    }
    stage('Environment Setup') {
      steps {
        sh 'make env'
      }
    }
    stage('Pybind11') {
      steps {
        sh '''cd pybind11;
../bin/python3 setup.py build
../bin/python3 setup.py install'''
      }
    }
    stage('Pytorch') {
      steps {
        timestamps() {
          sh '''# Build pytorch
: Build pytorch
cd pytorch
../bin/python3 setup.py build'''
        }

      }
    }
  }
}