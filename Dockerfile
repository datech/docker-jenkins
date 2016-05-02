FROM centos:centos6.7

# for main web interface:
EXPOSE 8080
# will be used by attached slave agents:
EXPOSE 50000

ENV JENKINS_HOME /opt/jenkins

ARG user=jenkins

ENV JENKINS_UID 1000
ENV JENKINS_GID 1000
ENV JENKINS_USER ${user}
ENV JENKINS_GROUP "jenkins"

COPY provision /opt/provision

RUN /opt/provision/pre-provision.sh

USER ${user}

RUN /opt/provision/provision.sh

ENTRYPOINT /usr/local/bin/jenkins.sh
