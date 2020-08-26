#!/bin/bash
docker run -it --name=rosdev_container --rm --net=host \
            -v /mnt/c/Users/ferzm/rosdev/src/drive_car/:/catkin_ws/src/drive_car/ \
            -v /mnt/c/Users/ferzm/rosdev/src/laser_scan/:/catkin_ws/src/laser_scan/ \
            -v /mnt/c/Users/ferzm/rosdev/src/location_monitor/:/catkin_ws/src/location_monitor/ \
            -v /mnt/c/Users/ferzm/rosdev/src/ros_wall_follower/:/catkin_ws/src/ros_wall_follower/ \
            -e QT_GRAPHICSSYSTEM=native \
            rosdev:latest

# -v /mnt/c/Users/ferzm/project/src:/root/ferzm/project/src
# --mount source=/mnt/c/Users/ferzm/project/src/,target=/root/ferzm/,type=bind