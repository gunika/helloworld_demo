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
					
					rtMaven.deployer server: server, releaseRepo: 'helloworld_demo', snapshotRepo: 'helloworld_demo'
					rtMaven.tool = 'default'
					def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'install'
					server.publishBuildInfo buildInfo
					}
			}
		}


	}
}
