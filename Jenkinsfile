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
				withMaven(maven : 'maven'){
					sh 'mvn install'
				}
			}
		}

		stage ('SonarQube Analysis'){
		
			steps{
			
				withSonarQubeEnv('sonar') {
					sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'

				}
			}
		}

		stage ('Artifactory Deploy'){
		
			steps{
				script {
					def server = Artifactory.server('default')
					def rtMaven = Artifactory.newMavenBuild()
					
					rtMaven.deployer server: server, releaseRepo: 'devops.lab.session'
					rtMaven.tool = 'maven'
					def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'install'
					server.publishBuildInfo buildInfo
					}
			}
		}
		stage('Docker Image Release') {
      
            steps {
             		sh 'wget -O HelloDevOps.war http://3.17.20.253:8081/artifactory/devops.lab.session/com/nagarro/devops/lab/session/devops.lab/0.0.1-SNAPSHOT/devops.lab-0.0.1-SNAPSHOT.war'
               		sh 'docker build -t i_devops_lab_session .'
                  }
        }


		stage('Docker Deployment') {
      
            steps {
            		portCheck(9690)
                	sh 'docker run --name c_devops_lab_session -d -p 9690:8080 i_devops_lab_session'
                  }
        }

 

	}
}
