FROM ubuntu:24.04

ARG USER
ARG PASSWORD
ARG GIT_EMAIL
ARG GIT_NAME

ARG HOME=/home/${USER}

USER root

# update packages
RUN set -x && \
    apt update && \
    apt upgrade -y

# install packages
RUN set -x && \
    apt install -y wget sudo git vim sudo curl libssl-dev tmux gcc make \
    pkg-config g++ cmake

# share
RUN set -x && \
    mkdir -p /share

# user
RUN set -x && \
    useradd -s /bin/bash -m ${USER} && \
    gpasswd -a ${USER} sudo && \
    echo "${USER}:${PASSWORD}" | chpasswd

ENV LANG=ja_JP.UTF-8

USER ${USER}
WORKDIR ${HOME}

# git
RUN set -x && \
    git config --global user.email ${GIT_EMAIL} && \
    git config --global user.name "${GIT_NAME}" && \
    git config --global log.decorate auto && \
    git config --global credential.helper store

# tmux
RUN set -x && \
    echo "set -g prefix C-t\nunbind C-b\n" > /home/${USER}/.tmux.conf

# uv
RUN set -x && \
    curl -LsSf https://astral.sh/uv/install.sh | sh

# rust
RUN set -x && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
