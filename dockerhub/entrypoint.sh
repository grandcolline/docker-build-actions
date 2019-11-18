#!/bin/sh

# DockerHub Login
docker login -u ${INPUT_USERNAME} -p ${INPUT_PASSWORD}

# Add Tags
for tag in ${INPUT_TAGS}
do
	if [ "${tag}" = "SHORT_SHA" ]; then
		tag=$(echo ${GITHUB_SHA} | cut -c 1-7)
	elif [ "${tag}" = "BRANCH" ]; then
		tag=$(echo ${GITHUB_REF} | rev | cut -f 1 -d / | rev)
	fi
	echo "${tag}"
	docker tag githubactions_temporary_image:latest ${INPUT_IMAGE}:${tag}
done

# Push
docker push ${INPUT_IMAGE}

