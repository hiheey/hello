pipeline {
    agent any

    environment{
        REGION = 'ap-northeast-2'
        EKS_API = {EKS Cluster Api Server Endpoint}
        EKS_CLUSTER_NAME = {EKS Cluster 이름}
       EKS_JENKINS_CREDENTIAL_ID = 'kubectl-deploy-credentials'
       ECR_PATH = {ECR로 가서 Repository의 URI을 가져오되 /repository-name 은 제거}
       ECR_IMAGE = 'ecr 이미지 이름'
       AWS_CREDENTIAL_ID = 'AWSCredentials'

    }
    stages {
        stage('Clone Repository'){
            checkout scm
        }
        stage('Docker Build'){
        docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}"){
            image = docker.build("${ECR_PATH}/${ECR_IMAGE}")
            }
        }
        stage('Push to ECR'){
            docker.withRegistry("https://{ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_ID}"){
                image.push("v${env.BUILD_NUMBER}")
            }
        }
        stage('CleanUp Images'){
            sh"""
            docker rmi ${ECR_PATH}/${ECR_IMAGE}:v$BUILD_NUMBER
            docker rmi ${ECR_PATH}/${ECR_IMAGE}:latest
            """
        }
        stage('Deploy to k8s'){
        withKubeConfig([credentialsId: "{EKS_JENKINS_CREDENTIAL_ID}",
                        serverUrl: "${EKS_API}",
                        clusterName: "${EKS_CLUSTER_NAME}"]){
            sh "sed 's/IMAGE_VERSION/v${env.BUILD_ID}/g' service.yaml > output.yaml"
            sh "aws eks --region ${REGION} update-kubeconfig --name ${EKS_CLUSTER_NAME}"
            sh "kubectl apply -f output.yaml"
            sh "rm output.yaml"
             }
        }
}
