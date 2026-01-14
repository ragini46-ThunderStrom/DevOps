pipeline {
  agent any
  environment {
    IMAGE_NAME = "ragini46/devops-demo"
    EC2_USER = "ubuntu"
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
        sh 'docker build -t $IMAGE_NAME:latest .'
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
        sh 'docker push $IMAGE_NAME:latest'
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
  
        docker run -d --name app -p 80:5000 $IMAGE_NAME:latest
        '
        '''
      }
    }
  }
}

