From tomcat
Run wget -O /usr/local/tomcat/webapps/HelloDevOps.war http://10.127.126.113:8081/artifactory/gunika/com/Nagarro/gunikajain/devops/helloworld/0.0.1-SNAPSHOT/helloworld-0.0.1-SNAPSHOT.war
Expose 8080
cmd /usr/local/tomcat/bin/cataline.sh run