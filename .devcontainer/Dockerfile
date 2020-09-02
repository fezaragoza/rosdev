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
                    gdb \
                    lsb-core \
                    wget

RUN /bin/bash -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt update

RUN apt install -y  gazebo9 \
                    libgazebo9-dev \
                    ros-melodic-gazebo-ros \
                    ros-melodic-gazebo-plugins \
                    ros-melodic-gazebo-ros-pkgs \
                    ros-melodic-gazebo-ros-control

RUN apt install -y  ros-melodic-ackermann-msgs \
                    ros-melodic-map-server \
                    ros-melodic-rviz \
                    ros-melodic-rqt \
                    ros-melodic-rqt-common-plugins \
                    ros-melodic-rqt-robot-plugins
    
RUN sudo rosdep fix-permissions

RUN rosdep update

# RUN curl -sSL http://get.gazebosim.org | sh

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
                numba==0.47.0 \
                pylint \
                autopep8 \
                pandas

RUN mkdir /f1tenth_gym
COPY ./f1tenth_gym_ros/f1tenth_gym /f1tenth_gym

RUN cd /f1tenth_gym && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

RUN cd /f1tenth_gym && \
    cp ./build/sim_requests_pb2.py ./gym/ && \
    pip install -e gym/

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; mkdir -p /catkin_ws/src/; cd /catkin_ws; catkin_make"

RUN mkdir /catkin_ws/src/f1tenth_gym_ros

COPY ./f1tenth_gym_ros /catkin_ws/src/f1tenth_gym_ros

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash"

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-drivers/rosserial.git && \
    cd rosserial && \
    git checkout melodic-devel

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; catkin_make install"

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3.git && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3_autorace.git

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; rosdep install --from-path src -i -y; \
                catkin_make; source devel/setup.bash; rospack profile"

# SLAM HECTOR
RUN apt install -y tmux \
                    qt4-default

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/tu-darmstadt-ros-pkg/hector_slam.git

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

COPY ./mapping_default.launch /catkin_ws/src/hector_slam/hector_mapping/launch/
COPY ./tutorial.launch /catkin_ws/src/hector_slam/hector_slam_launch/launch/

# SAVE MAP
RUN apt install -y libsdl-dev \
                    libsdl-image1.2-dev

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-planning/navigation.git && \
    cd navigation && \
    git checkout melodic-devel

# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros/geometry2.git && \
    cd geometry2 && \
    git checkout melodic-devel

# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-planning/navigation_msgs.git

# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-perception/openslam_gmapping.git && \
    cd openslam_gmapping && \
    git checkout melodic-devel

RUN cd /catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-perception/slam_gmapping.git && \
    cd slam_gmapping && \
    git checkout melodic-devel

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 


COPY ./start.sh $HOME/
# CMD ["/catkin_ws/src/f1tenth_gym_ros/start.sh"]
# RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "source ~/start.sh" >> ~/.bashrc

# CMD ["roslaunch", "package file.launch"]

WORKDIR /catkin_ws/src
CMD [ "/bin/bash" ]