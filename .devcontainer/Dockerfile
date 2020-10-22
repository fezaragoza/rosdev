FROM ros:melodic-robot-bionic

ENV IM_IN_DOCKER Yes

ARG USERNAME=ferzm
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

ENV HOME /home/$USERNAME

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

RUN sudo apt update --fix-missing && \
    sudo apt upgrade -y && \
    sudo apt install -y \
    python-pip

RUN sudo apt install -y libzmq3-dev \
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


RUN sudo /bin/bash -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN sudo apt update

RUN sudo apt install -y  gazebo9 \
                    libgazebo9-dev \
                    ros-melodic-gazebo-ros \
                    ros-melodic-gazebo-plugins \
                    ros-melodic-gazebo-ros-pkgs \
                    ros-melodic-gazebo-ros-control

RUN sudo apt install -y  ros-melodic-ackermann-msgs \
                    ros-melodic-map-server \
                    ros-melodic-rviz \
                    ros-melodic-rqt \
                    ros-melodic-rqt-common-plugins \
                    ros-melodic-rqt-robot-plugins
    
RUN sudo rosdep fix-permissions

RUN rosdep update

# RUN curl -sSL http://get.gazebosim.org | sh

RUN sudo cp -r /usr/include/eigen3/Eigen /usr/include

RUN cd $HOME && git clone https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git checkout tags/v3.8.0 && \
    git submodule update --init --recursive && \
    sudo ./autogen.sh && \
    sudo ./configure && \
    sudo make -j8 && \
    sudo make install && \
    sudo ldconfig && \
    sudo make clean && \
    cd .. && \
    sudo rm -r protobuf

RUN sudo pip install --upgrade pip

RUN sudo pip install numpy==1.16.0 \
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

RUN mkdir $HOME/f1tenth_gym
COPY --chown=$USERNAME ./f1tenth_gym_ros/f1tenth_gym $HOME/f1tenth_gym

RUN cd $HOME/f1tenth_gym && \
    mkdir build && \
    cd build && \
    sudo cmake .. && \
    sudo make

RUN cd $HOME/f1tenth_gym && \
    sudo cp ./build/sim_requests_pb2.py ./gym/ && \
    sudo pip install -e gym/

RUN sudo /bin/bash -c "source /opt/ros/melodic/setup.bash; mkdir -p ~/catkin_ws/src/; cd ~/catkin_ws; catkin_make"

RUN sudo chown -R ferzm ~/catkin_ws

RUN sudo mkdir $HOME/catkin_ws/src/f1tenth_gym_ros

COPY --chown=$USERNAME ./f1tenth_gym_ros $HOME/catkin_ws/src/f1tenth_gym_ros

RUN sudo /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make; source devel/setup.bash"

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-drivers/rosserial.git && \
    cd rosserial && \
    git checkout melodic-devel

RUN sudo /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make; catkin_make install"

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3.git && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git && \
    git clone --recurse-submodules https://github.com/ROBOTIS-GIT/turtlebot3_autorace.git

RUN sudo /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; rosdep install --from-path src -i -y; \
                catkin_make; source devel/setup.bash; rospack profile"

# SLAM HECTOR
RUN sudo apt install -y tmux \
                        qt4-default

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/tu-darmstadt-ros-pkg/hector_slam.git

RUN sudo /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make; source devel/setup.bash" 

COPY --chown=$USERNAME ./modif_ros/mapping_default.launch $HOME/catkin_ws/src/hector_slam/hector_mapping/launch/
COPY --chown=$USERNAME ./modif_ros/tutorial.launch $HOME/catkin_ws/src/hector_slam/hector_slam_launch/launch/

# SAVE MAP
RUN sudo apt install -y libsdl-dev \
                        libsdl-image1.2-dev

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-planning/navigation.git && \
    cd navigation && \
    git checkout melodic-devel

# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros/geometry2.git && \
    cd geometry2 && \
    git checkout melodic-devel

# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-planning/navigation_msgs.git

# RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make; source devel/setup.bash" 

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-perception/openslam_gmapping.git && \
    cd openslam_gmapping && \
    git checkout melodic-devel

RUN cd $HOME/catkin_ws/src && \
    git clone --recurse-submodules https://github.com/ros-perception/slam_gmapping.git && \
    cd slam_gmapping && \
    git checkout melodic-devel

RUN sudo /bin/bash -c "source /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make; source devel/setup.bash" 


COPY --chown=$USERNAME ./start_ub.sh $HOME/
# CMD ["/catkin_ws/src/f1tenth_gym_ros/start.sh"]
# RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "source ~/start_ub.sh" >> ~/.bashrc

# CMD ["roslaunch", "package file.launch"]

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,compat32,graphics,utility,video,display

COPY --chown=$USERNAME ./modif_ros/params.yaml $HOME/catkin_ws/src/f1tenth_gym_ros/

RUN sudo apt install -y libcanberra-gtk* \
                        python-opencv
# libcanberra-gtk0, libcanberra-gtk-module, libcanberra-gtk3, libcanberra-gtk3-module
# pip install jupyter
WORKDIR ${HOME}/catkin_ws/src
CMD [ "/bin/bash" ]