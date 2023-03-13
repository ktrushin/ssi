#!/bin/sh

set -e

######################### READ AND VALIDATE USER INPUT #########################
prog=$(basename $0)

help_msg="\
Description:
  The program enters in a Docker container for developing this project
  under Ubuntu of specified version. The respective Docker image and
  container are automatically created if they don't exist. After that,
  the container is started and bash is executed in it interactively.
  The program must be called from the project's root directory.

Usage:
  $prog [-h] [-v <ubuntu_version>]

Arguments:
Options:
  -h  Print this help message and exit

  -v <ubuntu_version>
    Version of the Ubuntu distribution to build the Docker image from.
    Supported values: 20.04 and 22.04. Default is 22.04."

abort() {
    echo "Error: $1" >&2
    exit 1
}

if [ ! -d ".git" ]; then
  abort "$prog must be called from the project's root directory."
fi

version="22.04"
while getopts "hv:" opt; do
  case "$opt" in
    h) echo "$help_msg"; exit 0;;
    v) version=$OPTARG;;
    *) abort "unrecognized option"; exit 1;;
  esac
done
shift $((OPTIND-1))

if [ "$version" != "20.04" -a "$version" != "22.04" ]; then
  abort "unsupported version: $version"
fi
version=$(echo "$version" | sed 's/\(.*\)\.04/\1/g')

############################ SET UP SOME CONSTANTS #############################
proj_name=$(basename $(pwd))
image_name=$proj_name
image_tag=u$version
container_name="${image_name}-${image_tag}"

############ CREATE DOCKER IMAGE AND CONTAINER IF THEY DO NOT EXIST ############
if [ -z "$(docker image ls -q $image_name:$image_tag)" ]; then
  docker image build -f ubuntu.dockerfile \
    --build-arg version=$version \
    --build-arg username=$(id -un) \
    --build-arg uid=$(id -u) \
    --build-arg gid=$(id -g) \
    -t $image_name:$image_tag .
fi

if [ -z "$(docker container ls -aq --filter name=$container_name)" ]; then
  docker container create \
    --tty --interactive --privileged --cap-add=SYS_PTRACE \
    --name=$container_name --hostname=$container_name --user=$(id -un) \
    --volume=$HOME:$HOME --workdir=$(pwd) \
    $image_name:$image_tag
fi

########## START DOCKER CONTAINER AND EXECUTE BASH INTERACTIVELY THERE #########
docker container start $container_name
docker container exec -it $container_name bash
