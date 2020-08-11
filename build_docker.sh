#!/bin/bash
if [ ! -d f1tenth_gym_ros ] ; then
    git clone https://github.com/f1tenth/f1tenth_gym_ros.git
else
    echo f1tenth_gym_ros exists, not cloning.
fi

cd f1tenth_gym_ros/

if [ ! -d f1tenth_gym ] ; then
    git clone https://github.com/f1tenth/f1tenth_gym
else
    echo f1tenth_gym exists, not cloning.
fi

cd ../
echo "Building Docker Image..."

docker build -t rosdev:latest -f ./.devcontainer/Dockerfile .