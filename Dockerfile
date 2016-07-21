FROM handcraftedbits/nginx-unit-java:8.92.14
MAINTAINER HandcraftedBits <opensource@handcraftedbits.com>

ARG BAMBOO_VERSION=5.12.3.1
ARG MAVEN_VERSION=3.3.9

ENV BAMBOO_HOME /opt/data/bamboo
ENV PATH ${PATH}:/opt/maven/bin

COPY data /

RUN apk update && \
  apk add ca-certificates wget && \

  cd /opt && \
  wget https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz && \
  tar -xzvf atlassian-bamboo-${BAMBOO_VERSION}.tar.gz && \
  rm atlassian-bamboo-${BAMBOO_VERSION}.tar.gz && \
  mv atlassian-bamboo-${BAMBOO_VERSION} bamboo && \
  wget http://apache.mirrors.pair.com/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
  tar -xzvf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
  rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
  mv apache-maven-${MAVEN_VERSION} maven && \

  apk del ca-certificates wget

EXPOSE 8085

CMD ["/bin/bash", "/opt/container/script/run-bamboo.sh"]
