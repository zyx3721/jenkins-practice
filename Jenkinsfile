pipeline {
    agent any

    tools {
        jdk 'jdk21' 
        maven 'maven-3.9.9'
    }

    environment {
        IMAGE_NAME = "demo-app"
        CONTAINER_NAME = "demo-container"
    }

    stages {
        stage('拉取代码') {
            steps {
                checkout scm
            }
        }

        stage('编译构建') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker 清理缓存（防构建失败）') {
            steps {
                script {
                    // 安全清理 Docker 构建缓存，不影响运行中的容器
                    sh "docker builder prune -a -f"
                }
            }
        }

        stage('构建并运行 Docker') {
            steps {
                script {
                    // 1. 构建镜像
                    sh "docker build -t ${IMAGE_NAME} ."
                    
                    // 2. 停止并删除旧容器
                    sh """
                        if [ \$(docker ps -aq --filter name=\${CONTAINER_NAME}) ]; then
                            docker stop \${CONTAINER_NAME}
                            docker rm \${CONTAINER_NAME}
                        fi
                    """
                    
                    // 3. 运行新容器
                    sh "docker run -d -p 8081:8080 --name \${CONTAINER_NAME} \${IMAGE_NAME}"
                }
            }
        }
    }
}
