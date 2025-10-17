FROM tomcat:9.0-jdk17-openjdk
COPY target/oneday /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh", "run"]