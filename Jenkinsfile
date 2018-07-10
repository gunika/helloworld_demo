pipeline{
	agent any

	stages{
		stage ('Compile Stage'){

			steps {
				withMaven(maven : 'default'){
					sh 'mvn clean compile'
				}
			}
		}
		stage ('Testing Stage'){

			steps {
				withMaven(maven : 'default'){
					sh 'mvn test'
				}
			}
		}
		stage ('SonarQube Analysis'){
		
			steps{
			
				withSonarQubeEnv('sonarqube') {
				sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'

				}
			}
		}
		stage ('Maven Install Stage'){

			steps {
				withMaven(maven : 'default'){
				sh 'mvn install'
				}
			}
		}
		stage ('Artifactory Deploy'){
		
			steps{
				script {
					def server = Artifactory.server('default')
					def rtMaven = Artifactory.newMavenBuild()
					
					rtMaven.deployer server: server, releaseRepo: 'gunika', snapshotRepo: 'gunika'
					rtMaven.tool = 'default'
					def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'install'
					server.publishBuildInfo buildInfo
					}
				}
		}
		stage('Docker Deployment') {
      
            steps {
             	sh 'wget -O HelloDevOps.war http://10.127.126.113:8081/artifactory/gunika/com/nagarro/devops/training/2018/gunika/pipelines/helloDevops/0.0.1-SNAPSHOT/helloDevops-0.0.1-SNAPSHOT.war'
                sh 'docker build -t i_gunika_hellodevops .'
                sh 'docker rm -f c_gunika_hellodevops'
                sh 'docker run --name c_gunika_hellodevops -d -p 9690:8080 i_gunika_hellodevops'
                  }
        }
        		stage('LOG') {
      		     steps {
		     	     sh 'docker rm -f c_kibana'
		     	     sh 'docker rm -f c_elasticsearch'
		     	     sh 'docker run -d -p 9200:9200 -it -h elasticsearch --name c_elasticsearch elasticsearch'
		     	     sh 'docker run -d -p 5601:5601 -h kibana --name c_kibana --link c_elasticsearch:elasticsearch kibana'
		     	     sh 'sleep 20'
           		     logstashSend failBuild: true, maxLines: 1000

       			    }
			    }

		

		
	}
}
