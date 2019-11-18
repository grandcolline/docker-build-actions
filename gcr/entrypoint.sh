#!/bin/sh

# GCR Login
if [ -n "${INPUT_SERVICE_ACCOUNT_KEY}" ]; then
	echo "Logging into gcr.io with GCLOUD_SERVICE_ACCOUNT_KEY..."
	echo ${INPUT_SERVICE_ACCOUNT_KEY} | base64 --decode > /tmp/key.json
	gcloud auth activate-service-account --quiet --key-file /tmp/key.json
	gcloud auth configure-docker --quiet
else
	echo "SERVICE_ACCOUNT_KEY was empty, not performing auth" 1>&2
fi

# Add Tags
for tag in ${INPUT_TAGS}
do
	if [ "${tag}" = "SHORT_SHA" ]; then
		tag=$(echo ${GITHUB_SHA} | cut -c 1-7)
	elif [ "${tag}" = "BRANCH" ]; then
		tag=$(echo ${GITHUB_REF} | rev | cut -f 1 -d / | rev)
	fi
	echo "${tag}"
	docker tag githubactions_temporary_image:latest ${INPUT_REGISTRY}/${INPUT_IMAGE}:${tag}
done

# Push
docker push ${INPUT_REGISTRY}/${INPUT_IMAGE}

