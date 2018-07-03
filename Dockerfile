From tomcat
copy HelloDevOps.war /usr/local/tomcat/webapps/HelloDevOps.war
Expose 8080
cmd /usr/local/tomcat/bin/catalina.sh run