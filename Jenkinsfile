pipeline {
  agent any
  environment {
    IMAGE_NAME = "ragini46/devops-demo"
    EC2_USER = "ubuntu"
    IMAGE_TAG = "latest"
    FULL_IMAGE = "${IMAGE_NAME}:{IMAGE_TAG}"
    EC2_IP = "16.112.109.15"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build Image') {
      steps {
        sh 'docker build -t $FULL_IMAGE .'
      }
    }
    stage('Login to DockerHub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
      }
    }
    stage('push Image') {
      steps {
        sh 'docker push $FULL_IMAGE'
      }
    }
    stage('Deploy to EC2') {
      steps {
        sh '''
        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP '
        CONTAINER=\$(docker ps -aq -f name=app)
        if [ ! -z "\$CONTAINER" ]; then
          docker stop app
          docker rm app
        fi
  
        docker run -d --name app -p 80:5000 $FULL_IMAGE
        '
        '''
      }
    }
  }
}

