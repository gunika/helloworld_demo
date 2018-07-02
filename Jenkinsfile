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
		stage ('Install Stage'){

			steps {
				withMaven(maven : 'default'){
				sh 'mvn install'
				}
			}
		}
		stage('Docker Build') {
      
            steps {
                sh 'docker build -t i_gunika_hellodevops .'
                sh 'docker rm -f c_gunika_hellodevops'
                sh 'docker run --name c_gunika_hellodevops -d -p 9690:8080 i_gunika_hellodevops'
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

		
	}
}
