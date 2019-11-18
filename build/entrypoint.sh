#!/bin/sh
set -e

if [ ${INPUT_BUILDKIT} = "false" ]; then
	export DOCKER_BUILDKIT=0
else
	export DOCKER_BUILDKIT=1
fi

cd ${GITHUB_WORKSPACE}/${INPUT_WORKDIR}
docker build -f ${INPUT_DOCKERFILE} ${INPUT_ADD_OPTIONS} -t githubactions_temporary_image:latest .

