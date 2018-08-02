def portCheck(int p){
                  env.p=p;
                  sh '''
                   ContainerID=$(docker ps | grep $p | cut -d " " -f 1)
                   if [  $ContainerID ]
                   then
                      docker rm -f $ContainerID
                   fi
                     '''
                    }
pipeline{
	agent any

	stages{

		stage ('Test and Build'){

			steps {
				withMaven(maven : 'default'){
					sh 'mvn install'
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

		stage('Docker Image Release') {
      
            steps {
             		sh 'wget -O HelloDevOps.war http://10.127.126.113:8040/artifactory/gunika/com/nagarro/devops/training/2018/gunika/pipelines/helloDevops/0.0.1-SNAPSHOT/helloDevops-0.0.1-SNAPSHOT.war'
               		sh 'docker build -t i_gunika_hellodevops .'
                  }
        }

		stage('Docker Deployment') {
      
            steps {
            		portCheck(9690)
                	sh 'docker run --name c_gunika_hellodevops -d -p 9690:8080 i_gunika_hellodevops'
                  }
        }

        stage('Setup ELK') {
      		steps{
            		portCheck(9200)
		     	    sh 'docker run -d -p 9200:9200 -it -h elasticsearch --name c_gunika_elasticsearch elasticsearch'
      				portCheck(5601)
		     	    sh 'docker run -d -p 5601:5601 -h kibana --name c_kibana --link c_gunika_elasticsearch:elasticsearch kibana'
		     	    sh 'sleep 30'
           		    logstashSend failBuild: true, maxLines: 1000

       		}
	    }
	}
}
