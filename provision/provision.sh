#!/bin/bash

set -e

JENKINS_JOB_NAME=Seed

: ${JENKINS_VERSION:="1.658"}
: ${JENKINS_HOME:="/opt/jenkins"}

export JENKINS_HOME="$JENKINS_HOME"

curl -fSL http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war -o /usr/share/jenkins/jenkins.war

# Install plugins
plugins.sh /opt/provision/plugins.txt

# Start Jenkins
jenkins.sh > /tmp/startup.log 2>&1 &

maxloops=10
while ! grep "INFO: Jenkins is fully up and running" /tmp/startup.log
do
 if  [ $maxloops -lt 1 ] ; then
   echo "Max loop count reached - probably a bug in this script: $0"
   exit 1
 fi
 ((maxloops--))
 sleep 5;
done

# Set first jobs
curl -X POST "http://localhost:8080/createItem?name=$JENKINS_JOB_NAME" --data-binary "@/opt/provision/job-config.xml" -H "Content-Type: text/xml"
