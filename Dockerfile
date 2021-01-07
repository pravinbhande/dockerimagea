FROM openjdk:8-jdk-alpine

LABEL maintainer="Ravi Durge"  dockerfile_version="1.0.0"
WORKDIR /app
#ADD /home/ubuntu/kuliza/ravi-tomcat-04jan21/docker-tomcat-tutorial/sample.war /usr/local/tomcat/webapps/

#RUN rm -rf /opt/apache-tomcat-9.0.22/webapps/*
#ADD sample.war  /opt/apache-tomcat-9.0.22/webapps/
# Environment variables
ENV TOMCAT_MAJOR=9 \
    #TOMCAT_VERSION=8.5.37 \
    TOMCAT_VERSION=9.0.22 \
    CATALINA_HOME=/opt/tomcat

# install required packages
RUN apk -U upgrade --update && apk add curl && apk add ttf-dejavu
RUN adduser tomcatadmin --disabled-password

# create /opt directory
RUN mkdir -p /opt

# install tomcat
RUN curl -jkSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    ln -s /opt/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME

# cleanup
RUN apk del curl &&  rm -rf /tmp/* /var/cache/apk/*

COPY startup.sh /opt/startup.sh
COPY server.xml /opt/apache-tomcat-$TOMCAT_VERSION/conf/server.xml
RUN  mv /opt/apache-tomcat-$TOMCAT_VERSION/webapps/host-manager/manager.xml /opt/apache-tomcat-$TOMCAT_VERSION/webapps/host-manager/adm.xml
#COPY index.html /opt/apache-tomcat-9.0.22/webapps/docs/index.html
# create deployment directory
RUN mkdir -p /usr/local/tomcat/webapps/
RUN chmod -R 777 /usr/local/tomcat/webapps/
RUN rm -rf /usr/local/tomcat/webapps/*
ADD sample.war  /usr/local/tomcat/webapps/
RUN touch /opt/apache-tomcat-9.0.22/webapps/ROOT/index.jsp
RUN chown -R tomcatadmin /opt/apache-tomcat-$TOMCAT_VERSION/
#COPY sample.war /usr/local/tomcat/webapps
USER  tomcatadmin

WORKDIR $CATALINA_HOME

ENTRYPOINT /opt/startup.sh
