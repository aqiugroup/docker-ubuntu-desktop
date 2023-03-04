#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "install tools for sad book"

############################# begin : sad #################################

apt-get update\
     && apt-get install -y libgoogle-glog-dev libyaml-cpp-dev \
        libpcl-dev libgmock-dev \
        ros-noetic-velodyne-msgs

LOCAL_WS=/root/slam/catkin_ws
cd $LOCAL_WS/src \
    && git clone https://github.com/stevenlovegrove/Pangolin.git \
    && cd Pangolin \
    && mkdir build && cd build && cmake .. && make && make install \
    && cd $LOCAL_WS/src \
    && rm -rf Pangolin \

# cd $LOCAL_WS/src \
#     && git clone --recursive https://github.com/stevenlovegrove/Pangolin.git \
#     && cd Pangolin \
#     && ./scripts/install_prerequisites.sh recommended \
#     && cmake -B build \
#     && cmake --build build
############################# end : sad #################################


# apt-get clean -y
