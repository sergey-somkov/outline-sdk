# Build outline-cli inside docker container.

set -e
set -u

OUTLINE_CLI_DIR=$(dirname $(realpath ${0}))/
OUTLINE_SDK_DIR=${OUTLINE_CLI_DIR}../../../

sudo docker run --name=outline-cli \
	-it --rm \
	--network=host \
	--mount=type=bind,source=${OUTLINE_SDK_DIR},target=/outline-sdk \
	--workdir=/outline-sdk/x/examples/outline-cli/ \
	golang:latest \
	go build -o outline-cli -buildvcs=false