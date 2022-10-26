#!/bin/bash
if [ -d "/opt/maven-cache" ]
then
  mkdir -p ${MAVEN_REPO}
  mv ${MAVEN_CACHE}/* ${MAVEN_REPO}/
fi
exec "$@"
