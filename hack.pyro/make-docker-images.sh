#!/usr/bin/env bash

#!/usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builds and pushes docker image for each demo microservice.

set -euo pipefail

# BEGIN PYROSCOPE MODIFICATION
HACK_PYRO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTDIR="$(realpath "${HACK_PYRO_DIR}/../hack")"

TAG="${TAG:-v0.0.0-pyro}"
REPO_PREFIX="${REPO_PREFIX:-gcr.io/google-samples/microservices-demo}"

PYRO_PUSH=""
case "${1-}" in
    --pyro-push) PYRO_PUSH=1; shift;;
esac
# END PYROSCOPE MODIFICATION

log() { echo "$1" >&2; }

while IFS= read -d $'\0' -r dir; do
    # build image
    svcname="$(basename "${dir}")"
    builddir="${dir}"
    #PR 516 moved cartservice build artifacts one level down to src
    if [ $svcname == "cartservice" ]
    then
        builddir="${dir}/src"
    fi
    image="${REPO_PREFIX}/$svcname:$TAG"
    (
        cd "${builddir}"
        log "Building: ${image}"
        docker build -t "${image}" .

        # BEGIN PYROSCOPE MODIFICATION
        if [[ -n $PYRO_PUSH ]]; then
            log "Pushing: ${image}"
            docker push "${image}"
        fi
        # END PYROSCOPE MODIFICATION
    )
done < <(find "${SCRIPTDIR}/../src" -mindepth 1 -maxdepth 1 -type d -print0)

# BEGIN PYROSCOPE MODIFICATION
if [[ -n $PYRO_PUSH ]]; then
    log "Successfully built and pushed all images."
else
    log "Successfully built all images."
fi
# END PYROSCOPE MODIFICATION
