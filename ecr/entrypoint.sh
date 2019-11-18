#!/bin/sh

export AWS_ACCESS_KEY_ID=${INPUT_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${INPUT_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=${INPUT_REGION}

# Create Registory Name
if [ "${INPUT_REGISTRY}" == "" ]; then
	ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
	REGISTRY="${ACCOUNT_ID}.dkr.ecr.${INPUT_REGION}.amazonaws.com"
else
	REGISTRY="${INPUT_REGISTRY}"
fi

# ECR login
$(aws ecr get-login --no-include-email)

# Add Tags
for tag in ${INPUT_TAGS}
do
	if [ "${tag}" = "SHORT_SHA" ]; then
		tag=$(echo ${GITHUB_SHA} | cut -c 1-7)
	elif [ "${tag}" = "BRANCH" ]; then
		tag=$(echo ${GITHUB_REF} | rev | cut -f 1 -d / | rev)
	fi
	docker tag githubactions_temporary_image:latest ${REGISTRY}/${INPUT_IMAGE}:${tag}
done

# Push
docker push ${REGISTRY}/${INPUT_IMAGE}

