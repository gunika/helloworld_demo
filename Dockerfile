From tomcat
copy devopsLab.war /usr/local/tomcat/webapps/devopsLab.war
Expose 8080
cmd /usr/local/tomcat/bin/catalina.sh run
