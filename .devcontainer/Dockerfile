FROM ros:melodic-robot-bionic

ENV IM_IN_DOCKER Yes
ENV HOME /root

RUN apt update --fix-missing && \
    apt upgrade -y && \
    apt install -y \
    python-pip

RUN apt install -y libzmq3-dev \
                    git \
                    build-essential \
                    autoconf \
                    libtool \
                    libeigen3-dev \
                    cmake \
                    vim \
                    gdb

RUN apt install -y  ros-melodic-ackermann-msgs \
                    ros-melodic-map-server \
                    ros-melodic-rviz \
                    ros-melodic-rqt \
                    ros-melodic-rqt-common-plugins \
                    ros-melodic-rqt-robot-plugins
    
RUN sudo rosdep fix-permissions

RUN rosdep update

RUN curl -sSL http://get.gazebosim.org | sh

RUN cp -r /usr/include/eigen3/Eigen /usr/include

RUN git clone https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git checkout tags/v3.8.0 && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure && \
    make -j8 && \
    make install && \
    ldconfig && \
    make clean && \
    cd .. && \
    rm -r protobuf

RUN pip install --upgrade pip

RUN pip install numpy==1.16.0 \
                scipy==1.2.0 \
                zmq \
                pyzmq \
                Pillow \
                gym \
                protobuf==3.8.0 \
                pyyaml \
                llvmlite==0.31.0 \
                numba==0.47.0

RUN mkdir $HOME/f1tenth_gym
COPY ./f1tenth_gym_ros/f1tenth_gym $HOME/f1tenth_gym

RUN cd $HOME/f1tenth_gym && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

RUN cd $HOME/f1tenth_gym && \
    cp ./build/sim_requests_pb2.py ./gym/ && \
    pip install -e gym/

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; mkdir -p ~/catkin_ws/src/; cd ~/catkin_ws; catkin_make"

RUN mkdir $HOME/catkin_ws/src/f1tenth_gym_ros

COPY ./f1tenth_gym_ros $HOME/catkin_ws/src/f1tenth_gym_ros

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make; source devel/setup.bash"

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-drivers/rosserial.git

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make; catkin_make install"


COPY ./start.sh $HOME/
# CMD ["/catkin_ws/src/f1tenth_gym_ros/start.sh"]
# RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "source ~/start.sh" >> ~/.bashrc

# CMD ["roslaunch", "package file.launch"]

WORKDIR $HOME/ws
CMD [ "/bin/bash" ]