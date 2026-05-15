FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes /etc/dpkg/dpkg.cfg.d/docker-clean \
    && apt-get update && yes | unminimize

RUN apt-get install -y \
    bash \
    vim \
    curl \
    python3 \
    python3-pip \
    man-db \
    manpages \
    manpages-posix \
    groff \
    coreutils \
    findutils \
    grep \
    unzip \
    # reinstall restores man pages stripped by the docker-clean config
    && apt-get install --reinstall -y coreutils findutils \
    && rm -rf /var/lib/apt/lists/*

RUN mandb

RUN pip3 install --no-cache-dir --break-system-packages fastapi uvicorn tldr && \
    rm -f /usr/local/bin/uvicorn /usr/local/bin/fastapi

RUN useradd -m -s /bin/bash ctf

COPY --chown=ctf:ctf . /home/ctf/challenges

RUN CHALLENGES_DIR=/home/ctf/challenges python3 /home/ctf/challenges/docker/setup_bins.py

COPY docker/check.sh /usr/local/bin/check
COPY docker/cmds.sh /usr/local/bin/cmds
RUN chmod +x /usr/local/bin/check /usr/local/bin/cmds

# vimrc prevents :! shell escapes in vim challenges
RUN mkdir -p /etc/vim
COPY docker/restricted_vimrc /etc/vim/restricted_vimrc

COPY docker/launcher.sh /usr/local/bin/launcher
RUN chmod +x /usr/local/bin/launcher

ENV CHALLENGES_DIR=/home/ctf/challenges
ENV BINS_DIR=/bins

USER ctf
WORKDIR /home/ctf
RUN tldr --update
CMD ["/usr/local/bin/launcher"]
