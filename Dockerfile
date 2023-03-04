# This Dockerfile is used to build an vnc image based on Ubuntu

FROM osrf/ros:noetic-desktop-full

LABEL maintainer="aqiuxx<1457615966@qq.com>"

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/root \
    TERM=xterm \
    STARTUPDIR=/root/docker-ubuntu-desktop/src/scripts \
    INST_SCRIPTS=/root/docker-ubuntu-desktop/src/install \
    SOFTWARE_CONFIGS=/root/docker-ubuntu-desktop/src/config \
    NO_VNC_HOME=/opt/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/install/ $INST_SCRIPTS/

### change ubuntu/ros source
RUN apt-get clean \
    && rm -f /etc/apt/sources.list.d/ros1-latest.list \
    && sed -i 's#http://archive.ubuntu.com#https://mirrors.aliyun.com#g' /etc/apt/sources.list \
    && sed -i 's#http://security.ubuntu.com#https://mirrors.aliyun.com#g' /etc/apt/sources.list \
    && sed -i 's#http://packages.ros.org/ros#http://mirrors.tuna.tsinghua.edu.cn/ros#g' /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list \
    && sed -i 's#http://packages.ros.org/ros#http://mirrors.tuna.tsinghua.edu.cn/ros#g' /etc/apt/sources.list.d/ros-latest.list \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && apt-get clean

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh

### Install chrome browser
RUN $INST_SCRIPTS/chrome.sh

### Install ibus-pinyin
RUN $INST_SCRIPTS/ibuspinyin.sh



### 一级缓存：install_WIP，为了加速，Install ros tools.
ADD ./src/install_WIP/ $INST_SCRIPTS/
ADD ./src/config/ $SOFTWARE_CONFIGS/
RUN $INST_SCRIPTS/tools_for_ros.sh

### 二级缓存：install_WIP2，为了加速
ADD ./src/install_WIP2/ $INST_SCRIPTS/
RUN $INST_SCRIPTS/tools_for_sad_book.sh

# RUN chown root:root -R /root
ADD ./src/scripts/ $STARTUPDIR/


ENTRYPOINT ["/root/docker-ubuntu-desktop/src/scripts/vnc_startup.sh"]
CMD ["--wait"]
