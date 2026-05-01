FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bash \
    vim \
    curl \
    python3 \
    python3-pip \
    man-db \
    groff \
    coreutils \
    findutils \
    grep \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages fastapi uvicorn

# Create the CTF user
RUN useradd -m -s /bin/bash ctf

# Copy challenges into the ctf user's home so they can write files
# (challenges need to write flag.txt, output.txt, etc.)
COPY --chown=ctf:ctf . /home/ctf/challenges

# Build per-challenge symlink trees in /bins using the writable path
RUN CHALLENGES_DIR=/home/ctf/challenges python3 /home/ctf/challenges/docker/setup_bins.py

# Install the check and help commands globally
COPY docker/check.sh /usr/local/bin/check
COPY docker/help.sh /usr/local/bin/help
RUN chmod +x /usr/local/bin/check /usr/local/bin/help

# Install restricted vimrc (prevents :! shell escapes in vim challenges)
RUN mkdir -p /etc/vim
COPY docker/restricted_vimrc /etc/vim/restricted_vimrc

# Install launcher
COPY docker/launcher.sh /usr/local/bin/launcher
RUN chmod +x /usr/local/bin/launcher

ENV CHALLENGES_DIR=/home/ctf/challenges
ENV BINS_DIR=/bins

EXPOSE 8080

USER ctf
WORKDIR /home/ctf
CMD ["/usr/local/bin/launcher"]
