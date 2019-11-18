#!/bin/sh

# Create Repository Name
if [ "${INPUT_REPOSITORY}" == "" ]; then
	REPOSITORY=${GITHUB_REPOSITORY}
else
	REPOSITORY=${INPUT_REPOSITORY}
fi

# Login
docker login docker.pkg.github.com -u ${INPUT_USERNAME} -p ${INPUT_TOKEN}

# Add tags
for tag in ${INPUT_TAGS}
do
	if [ "${tag}" = "SHORT_SHA" ]; then
		tag=$(echo ${GITHUB_SHA} | cut -c 1-7)
	elif [ "${tag}" = "BRANCH" ]; then
		tag=$(echo ${GITHUB_REF} | rev | cut -f 1 -d / | rev)
	fi
	echo "${tag}"
	docker tag githubactions_temporary_image:latest docker.pkg.github.com/${REPOSITORY}/${INPUT_IMAGE}:${tag}
done

# Push
docker push docker.pkg.github.com/${REPOSITORY}/${INPUT_IMAGE}

