#!/bin/bash
docker run -it --name=rosdev_container --rm --net=host \
            -v /mnt/c/Users/ferzm/project/src:/root/ws/src \
            -e QT_GRAPHICSSYSTEM=native \
            rosdev:latest

# -v /mnt/c/Users/ferzm/project/src:/root/ferzm/project/src
# --mount source=/mnt/c/Users/ferzm/project/src/,target=/root/ferzm/,type=bind