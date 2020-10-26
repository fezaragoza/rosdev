#!/bin/bash
xhost +local:docker
nvidia-docker run --privileged --rm --gpus all -it --name=rosdev_container --net=host \
            --runtime=nvidia \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v /home/ferzm/rosdev/src/ros_wall_follower/:/home/ferzm/catkin_ws/src/ros_wall_follower/ \
            --user $(id -u):$(id -g)\
            rosdev:latest
            # -v /home/ferzm/rosdev/src/location_monitor/:/home/ferzm/catkin_ws/src/location_monitor/ \
            # -v /mnt/c/Users/ferzm/rosdev/src/drive_car/:/catkin_ws/src/drive_car/ \
            # -v /mnt/c/Users/ferzm/rosdev/src/laser_scan/:/catkin_ws/src/laser_scan/ \
            # -e XAUTHORITY \
            # -v $HOME/.Xauthority:/home/test/.Xauthority \
            

# -v /mnt/c/Users/ferzm/project/src:/root/ferzm/project/src
# --mount source=/mnt/c/Users/ferzm/project/src/,target=/root/ferzm/,type=bind