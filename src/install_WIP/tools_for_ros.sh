#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some common tools for ros(bring from kalibr)"

########################### begin get from kalibr ###################################
# https://github.com/ethz-asl/kalibr/wiki/installation
apt-get install -y \
    git wget autoconf automake nano \
    python3-dev python3-pip python3-scipy python3-matplotlib \
    ipython3 python3-wxgtk4.0 python3-tk python3-igraph \
    libeigen3-dev libboost-all-dev libsuitesparse-dev \
    doxygen \
    libopencv-dev \
    libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev \
    python3-catkin-tools python3-osrf-pycommon \
    && rm -rf /var/lib/apt/lists/*

# Create the workspace and build kalibr in it
LOCAL_WS=/root/slam/catkin_ws
mkdir -p $LOCAL_WS/src && \
    cd $LOCAL_WS && \
    catkin init && \
    catkin config --extend /opt/ros/noetic && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release
############################# end get from kalibr #################################

apt-get clean -y

########################### copy terminator config ###################################
# copy terminator config
cp $SOFTWARE_CONFIGS/terminator /root/.config -r
########################### set ros env ###################################


########################### set ros env ###################################
# cp /usr/share/applications/terminator.desktop /root/Desktop
echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
########################### set ros env ###################################
