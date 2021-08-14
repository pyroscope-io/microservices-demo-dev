#!/usr/bin/env bash

set -e

#------------------------------------------------------------------------------

REPO_NAME=pyroscope-helm-charts
CHART_NAME=microservices-demo
CHART_PATH="charts/${CHART_NAME}"

VERSION=${VERSION:-0.0.0}
APP_VERSION=${APP_VERSION:-$VERSION}
CHART_VERSION=${CHART_VERSION:-$VERSION}

#------------------------------------------------------------------------------

output_dir=bin
mkdir -p "${output_dir}"

helm plugin install https://github.com/hypnoglow/helm-s3.git &> /dev/null || true

helm repo add "${REPO_NAME}" "s3://${REPO_NAME}"

helm package "${CHART_PATH}" \
  --destination "${output_dir}" \
  --version "${CHART_VERSION}" \
  --app-version "${APP_VERSION}"

helm s3 push --force "${output_dir}/${CHART_NAME}-${CHART_VERSION}.tgz" "${REPO_NAME}"

# TODO: update version in Chart.yaml and values.yaml
