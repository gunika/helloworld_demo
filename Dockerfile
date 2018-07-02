From tomcat
run rm -f /usr/local/tomcat/webapps/HelloDevOps.war
run wget -O /usr/local/tomcat/webapps/HelloDevOps.war http://10.127.126.113:8081/artifactory/gunika/com/nagarro/devops/training/2018/gunika/pipelines/helloDevops/0.0.1-SNAPSHOT/helloDevops-0.0.1-SNAPSHOT.war
Expose 8080
cmd /usr/local/tomcat/bin/catalina.sh run