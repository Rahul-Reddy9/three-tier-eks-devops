pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '949677835392'
        ECR_REPO = '949677835392.dkr.ecr.ap-south-1.amazonaws.com/threetier-frontend'
        EKS_CLUSTER = 'threetier-eks'
        NAMESPACE = 'workshop'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Frontend') {
            steps {
                bat 'docker build -t threetier-frontend:%BUILD_NUMBER% .\\app\\frontend'
            }
        }

        stage('Login to ECR') {
            steps {
                bat 'cmd /c "aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.ap-south-1.amazonaws.com"'
            }
        }

        stage('Push Frontend Image') {
            steps {
                bat 'docker tag threetier-frontend:%BUILD_NUMBER% %ECR_REPO%:%BUILD_NUMBER%'
                bat 'docker push %ECR_REPO%:%BUILD_NUMBER%'
            }
        }

        stage('Deploy to EKS') {
            steps {
                bat 'aws eks update-kubeconfig --name %EKS_CLUSTER% --region %AWS_REGION%'
                bat 'kubectl set image deployment/frontend frontend=%ECR_REPO%:%BUILD_NUMBER% -n %NAMESPACE%'
                bat 'kubectl rollout status deployment/frontend -n %NAMESPACE%'
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD pipeline failed. Check the stage logs.'
        }
    }
}
