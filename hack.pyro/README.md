## `hack.pyro`

This directory provides scripts for building and publishing Docker images with
modification for adding Pyroscope.

Changes should be made only in this directory to make it easier to keep update
with the upstream code. All changes should be tagged with `pyroscope` or `PYRO`
for easier searching later.

### scripts

#### `make-docker-images.sh`

Builds and optionally pushes images to the specified Docker repository. Add
`--pyro-push` to push the images.

```sh
# change prefix to your image repository
export REPO_PREFIX=gcr.io/google-samples/microservices-demo
export TAG=v0.0.0
hack.pyro/make-docker-images.sh [--pyro-push]
```

#### `make-release-artifacts.sh`

This script compiles manifest files with the image tags and places them in the
`release.pyro` directory.

```sh

# change prefix to your image repository
export REPO_PREFIX=gcr.io/google-samples/microservices-demo
export TAG=v0.0.0
export OUT_DIR=release.pyro
hack.pyro/make-release-artifacts.sh
```
