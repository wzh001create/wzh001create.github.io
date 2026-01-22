---
title: "Docker 化迁移实战：将 C++ 项目容器化"
date: 2025-09-19T16:17:18+08:00
draft: false
tags: ["Docker", "C++", "容器化"]
categories: ["项目实战"]
author: "WangZhenhao"
---

hello,world!
这是我用 **Hugo** 创建的第一篇博客文章。感觉太棒了！

<!--more-->

## 工作日志 - 项目 Docker 化迁移

**日期：** 2025年8月19日
**记录人：** 我

### 一、项目目标

为了将我的高光谱 C++ 项目（GGP2）从当前开发主机便捷地迁移到其他主机，避免重复搭建复杂的编译和运行环境（特别是特定版本的 OpenCV 4.10、Pylon SDK 和众多系统库），我决定采用 Docker 技术对整个项目进行容器化封装，实现"一次构建，到处运行"。

### 二、今日主要工作内容

1.  **依赖分析**：基于项目的 `ldd` 输出和 `CMakeLists.txt` 文件，系统性地分析了项目在编译时和运行时所需的所有依赖库，包括系统库 (`libfmt`, `libtiff` 等)、从源码编译的 OpenCV 4.10、以及第三方的 Pylon SDK 和私有镜头库。
2.  **构建环境准备**：创建了一个专门的 `docker_project` 目录，将项目源码、`Dockerfile`、以及所有本地依赖包（`pylon.zip`, `opencv-4.10.0_2.zip`, `opencv_contrib-4.10.0.zip`）集中存放，作为 Docker 的构建上下文。
3.  **Dockerfile 编写与迭代**：编写了初版的 `Dockerfile`，并根据今天遇到的一系列问题，对其进行了多次迭代和优化，使其更加健壮和精确。
4.  **反复构建与调试**：多次尝试执行 `docker build` 命令，并根据报错信息定位问题、修正 `Dockerfile`，直至解决所有环境和配置相关的错误。

### 三、遇到的问题及解决方案

今天的工作充满了挑战，但也收获颇丰，主要解决了以下几个关键问题：

1.  **问题：`docker build` 命令语法错误**
    *   **现象**：初次执行 `docker build -t hyperspectral-app:1.0` 时，系统报错 `requires 1 argument`。
    *   **原因分析**：命令末尾遗漏了构建上下文路径参数。
    *   **解决方案**：修正命令为 `docker build -t hyperspectral-app:1.0 .`，明确告知 Docker 使用当前目录作为构建上下文。

2.  **问题：Docker 命令权限不足 (`permission denied`)**
    *   **现象**：修正命令后，执行时报错 `permission denied while trying to connect to the Docker daemon socket`。
    *   **原因分析**：当前用户（wzh111）不在 `docker` 用户组中，没有权限与 Docker 守护进程通信。
    *   **解决方案**：执行 `sudo usermod -aG docker ${USER}` 将当前用户添加到 `docker` 组，然后**注销并重新登录**系统以使用户组变更生效。

3.  **问题：`apt` 包名不匹配导致安装失败**
    *   **现象**：构建过程中，在 `apt-get install` 步骤报错 `Unable to locate package libusb-1.0-dev`。
    *   **原因分析**：我们选择的 `builder` 基础镜像 `python:3.11.10-bookworm` 底层是 Debian 系统，其软件包命名与 Ubuntu 不同。
    *   **解决方案**：查明 Debian 系统下对应的包名为 `libusb-1.0-0-dev`，并修正 `Dockerfile` 中的包名。

4.  **问题：Pylon 的 USB 设置脚本路径错误 (`not found`)**
    *   **现象**：执行 `RUN /opt/pylon/share/pylon/setup_usb.sh` 时，报错 `not found`。
    *   **原因分析**：脚本的实际路径与我们预想的不符。
    *   **解决方案（第一步）**：为了定位真实路径，在 `Dockerfile` 中加入了调试命令 `RUN ls -lR /opt/pylon`，希望能在构建日志中看到文件列表。

5.  **问题：Docker 构建缓存导致调试命令未执行**
    *   **现象**：再次构建时，并未看到 `ls` 命令的输出，直接跳到了失败的步骤。
    *   **原因分析**：Docker 的缓存机制认为之前的步骤没有变化，直接使用了缓存层，跳过了我们新加入的 `ls` 调试命令。
    *   **解决方案**：使用 `docker build --no-cache ...` 命令，强制 Docker 忽略所有缓存，从头开始执行每一步。

6.  **问题：容器内网络问题导致 `pip install numpy` 超时**
    *   **现象**：使用 `--no-cache` 重建后，构建在更早的 `pip3 install numpy` 步骤失败，报错 `ReadTimeoutError`，日志显示下载速度极慢。
    *   **原因分析**：容器内的网络环境访问 Python 官方源 `pypi.org` 存在网络瓶颈。
    *   **解决方案**：为 `pip` 命令更换为国内速度更快的清华大学镜像源。将命令修改为 `RUN pip3 install --default-timeout=100 -i https://pypi.tuna.tsinghua.edu.cn/simple numpy`，成功解决了网络超时问题。

### 四、当前进展

目前，我已经根据今天遇到的所有问题，生成了一份**高度优化的最终版 `Dockerfile`**。该文件解决了包命名、Docker 缓存、容器网络、Pylon 安装逻辑等多个关键问题。

**项目正处于使用这份最终 `Dockerfile` 进行新一轮构建的阶段。** 上一次的构建已成功通过了 `pip install numpy` 这一网络难关，证明网络问题已经解决。

### 五、后续计划

1.  **完成首次成功构建**：继续执行 `docker build` 命令，预期这次构建能够顺利通过所有依赖安装、OpenCV 编译和项目本身编译的步骤，最终成功生成 `hyperspectral-app:1.0` 镜像。
2.  **打包与迁移**：构建成功后，使用 `docker save` 将镜像打包，并将其迁移到目标新主机上。
3.  **部署与测试**：在新主机上使用 `docker load` 加载镜像，并运行 `docker run` 命令启动容器，最终验证程序能否正常识别相机并运行。
