#!/bin/bash

set -e

: ${JENKINS_UID:="1000"}
: ${JENKINS_GID:="1000"}

: ${JENKINS_USER:="jenkins"}
: ${JENKINS_GROUP:="jenkins"}

: ${JENKINS_HOME:="/opt/jenkins"}

groupadd -g ${JENKINS_GID} ${JENKINS_GROUP}
useradd -d "$JENKINS_HOME" -u ${JENKINS_UID} -g ${JENKINS_GID} -m -s /bin/bash ${JENKINS_USER}

mkdir -p /usr/share/jenkins/

cp /opt/provision/jenkins.sh /usr/local/bin/jenkins.sh
cp /opt/provision/plugins.sh /usr/local/bin/plugins.sh
chmod +x /usr/local/bin/plugins.sh /usr/local/bin/jenkins.sh

chown -R ${JENKINS_USER}:${JENKINS_GROUP} "$JENKINS_HOME" /opt/provision /usr/share/jenkins/

# Install needed 3rd party software
yum -y install java unzip
