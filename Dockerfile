FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes /etc/dpkg/dpkg.cfg.d/docker-clean
RUN apt-get update && yes | unminimize

RUN apt-get install -y \
    bash \
    vim \
    curl \
    python3 \
    python3-pip \
    man-db \
    manpages \
    groff \
    coreutils \
    findutils \
    grep \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages fastapi uvicorn && \
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

EXPOSE 8080

USER ctf
WORKDIR /home/ctf
CMD ["/usr/local/bin/launcher"]
