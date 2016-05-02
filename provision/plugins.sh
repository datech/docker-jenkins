#! /bin/bash

set -e

: ${JENKINS_HOME:="/opt/jenkins"}

JENKINS_UC=https://updates.jenkins.io
PLUGINS_DIR=${JENKINS_HOME}/plugins

mkdir -p "$PLUGINS_DIR"

installPlugin() {

  if [ -f ${PLUGINS_DIR}/${1}.hpi -o -f ${PLUGINS_DIR}/${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "- $1 (already installed)"
    return 0
  else
    curl -sSL -f ${JENKINS_UC_DOWNLOAD}/plugins/${1}/${2}/${1}.hpi -o $PLUGINS_DIR/${1}.jpi
    unzip -qqt $PLUGINS_DIR/${1}.jpi
   
    echo "- $1"

    deps=$( unzip -p $PLUGINS_DIR/${1}.jpi META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $deps; do
      installPlugin "$plugin" "latest"
    done

    return 0
  fi
}


while read spec || [ -n "$spec" ]; do
    plugin=(${spec//:/ });
    [[ ${plugin[0]} =~ ^# ]] && continue
    [[ ${plugin[0]} =~ ^\s*$ ]] && continue
    [[ -z ${plugin[1]} ]] && plugin[1]="latest"

    if [ -z "$JENKINS_UC_DOWNLOAD" ]; then
      JENKINS_UC_DOWNLOAD=$JENKINS_UC/download
    fi

    echo "Installing ${plugin[0]}:${plugin[1]} with dependencies"
    installPlugin ${plugin[0]} ${plugin[1]}
done  < $1
