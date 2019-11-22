#!/bin/bash

START_TIME=$(date +%s)

#WORK_DIR="$(mktemp -d)"
WORK_DIR="./fetch-tmp"
TMP_DIR="$(dirname "${WORK_DIR}")"
MVN="./apache-maven-3.5.3/bin/mvn -s settings.xml -Dmaven.repo.local=${WORK_DIR} -Dmaven.artifact.threads=10 -Dmaven.wagon.http.ssl.allowall=true"

trap "{ rm -rf ${WORK_DIR}; exit 255; }" SIGINT EXIT

echo "Temporary working directory:[$WORK_DIR]"
echo "Building temporary repository of dependencies..."

$MVN dependency:sources
$MVN dependency:resolve -Dclassifier=javadoc
$MVN package dependency:tree
rc=$?
if [[ $rc != 0 ]]; then
    echo "Unable to download artifacts"
    echo $rc
fi
$MVN dependency:tree

ARCHIVE="./MVNRepository-`date '+%F-%H-%M-%S'`.tar.gz"
touch $WORK_DIR/ArtifactDownloader.generated

tar czf $ARCHIVE -C ${WORK_DIR} .

echo "Created Maven Repository Archive [$ARCHIVE]"
END_TIME=$(date +%s)
COUNT=$(tar tf $ARCHIVE | grep pom$ | wc -l)
echo "Proccessed [$COUNT] artifacts in [$((END_TIME-START_TIME)) seconds.]"

