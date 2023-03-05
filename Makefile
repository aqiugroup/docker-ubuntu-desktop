.PHONY: build run

# Default values for variables
REPO  ?= aqiuxx/vnc-ros-noetic-full
REPO_TEST  ?= aqiuxx/vnc-ros-noetic-full2
TAG   ?= latest

CONTAINER ?= vnc-ros-noetic-full-test
CONTAINER_TEST ?= vnc-ros-noetic-full2-test

# Rebuild the container image
build: $(templates)
	docker build -t $(REPO):$(TAG) .

############################# 1 容器 begin ###################################
# 创建容器（一次性）
run-test:
	docker run --privileged --rm \
		-e VNC_RESOLUTION=3072x1920 \
		--name $(CONTAINER_TEST) \
		$(REPO_TEST):$(TAG) \

run-once:
	docker run --privileged --rm \
		-p 5901:5901 -p 6901:6901 \
		-v /Users/aqiu/Documents/1_study/10_workspace/00_AllMyXX/AllMySlam/Slam-Course/slam_in_autonomous_driving:/root/slam/sad \
		-e VNC_RESOLUTION=3072x1920 \
		--name $(CONTAINER) \
		$(REPO):$(TAG)

# --debug

# 创建容器
# -p 5901:5901 -p 6901:6901 \ 运行映射到本地端口 5901（vnc 协议）和 6901（vnc web 访问）的命令：
# -e VNC_RESOLUTION=3072x1920 \ ： 设置分辨率
# -e VNC_PASSWORDLESS=true \ ： 禁用密码
run:
	docker run --privileged -it \
		-p 5901:5901 -p 6901:6901 \
		-v /Users/aqiu/Documents/1_study/10_workspace/00_AllMyXX/AllMySlam/Slam-Course/slam_in_autonomous_driving:/root/slam/sad \
		-e VNC_RESOLUTION=3072x1920 \
		-e VNC_PASSWORDLESS=true \
		--name $(CONTAINER) \
		$(REPO):$(TAG)

# --network host \

# 重启关闭的容器
rerun:
	docker start $(CONTAINER)
	docker exec -it $(CONTAINER) bash

# 进入已打开的容器
exec:
	docker exec -it $(CONTAINER) bash

# 停止特定容器
stop:
	docker stop $(CONTAINER)

# 停止所有容器
stop-all:
	docker stop `docker ps -aq`
# docker stop $(docker ps -aq)


# 删除特定的停止运行的容器:
rm:
	docker rm ${CONTAINER}



# 下面三种写法都不正确
# https://breezetemple.github.io/2015/10/25/makefile-and-shell/
# g_a:=$(docker ps -a | grep Exited | awk '{print $1}')
# g_a:=$(docker ps -a | grep Exited | awk '{print $1}')
# g_a:=$(shell docker ps -a | grep Exited | awk '{print $1}')
g_exited_container:=$(shell docker ps -a | grep Exited | awk '{print $$1}')
rm-non:
	docker container prune -f
# docker rm $(g_exited_container)



# 删除所有停止运行的容器:
rm-all:
	docker container prune
# docker rm -f $(docker ps -aq)
############################# 1 容器 end ###################################

############################# 2 镜像 begin ###################################
# 特定的镜像
rmi:
	docker rmi $(REPO):$(TAG)
	docker image prune -f

# 删除镜像（non）
# 删除所有未被 tag 标记和未被容器使用的镜像:
rmi-non:
	docker image prune -f
# docker rmi -f `docker images | grep '<none>' | awk '{print \$3}'`
# docker rmi $(docker images | grep "<none>" | awk "{print \$3}")



# 删除所有未被容器使用的镜像:
# docker image prune -a
# WARNING! This will remove all images without at least one container associated to them.
# Are you sure you want to continue? [y/N] y
rmi-all:
	docker image prune -a
# docker rmi $(docker images -q)
############################# 2 镜像 end ###################################


############################# 3 镜像/容器 begin ###################################
# 删除 docker 所有资源(容器和镜像):
# docker system prune
# WARNING! This will remove:
#   - all stopped containers
#   - all networks not used by at least one container
#   - all dangling images
#   - all dangling build cache

# Are you sure you want to continue? [y/N] y
remove-all:
	docker system prune

# 删除所有网络:
# docker network prune
############################# 3 镜像/容器 end ###################################



############################# 4 显示可用的 镜像/容器 begin ###################################
# 必须加@，不然是乱序
p:
	@echo "------------all images-------------"
	docker images
	@echo "\n------------all containers-------------"
	docker ps -a
############################# 4 显示可用的  镜像/容器 begin ###################################
