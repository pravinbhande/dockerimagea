FROM openjdk:8-jdk-alpine

LABEL maintainer="Ravi Durge"  dockerfile_version="1.0.0"

# Environment variables
ENV TOMCAT_MAJOR=9 \
    #TOMCAT_VERSION=8.5.37 \
    TOMCAT_VERSION=9.0.22 \
    CATALINA_HOME=/opt/tomcat

# install required packages
RUN apk -U upgrade --update && apk add curl && apk add ttf-dejavu

RUN mkdir -p /opt

# install tomcat
RUN curl -jkSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    ln -s /opt/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME

# cleanup
RUN apk del curl &&  rm -rf /tmp/* /var/cache/apk/*

COPY startup.sh /opt/startup.sh

ENTRYPOINT /opt/startup.sh

WORKDIR $CATALINA_HOME
