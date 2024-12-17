FROM ubuntu:latest

RUN sed -i '/^path-exclude=\/usr\/share\/man/s/^/# /' /etc/dpkg/dpkg.cfg.d/excludes

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    openssh-server \
    sudo \
    zsh \
    man man-db manpages manpages-posix manpages-dev dialog \
    less groff \
    vim \
    git \
    python3-pip python3-venv \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# BEGIN locales for man
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN mv /usr/bin/man.REAL /usr/bin/man
RUN mandb -c
# RUN mkdir /tmp/manpages
# COPY --from=ubuntu:latest /usr/share/man/man1/* /tmp/manpages/

# Create the mandb database
# RUN mandb --create --user --quiet

# END locales setup

RUN mkdir /var/run/sshd

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# Do everything else before creating a user and cloning challenges
RUN useradd -ms /bin/bash ctfuser
RUN echo 'ctfuser:ctfpasswd' | chpasswd

USER ctfuser

#TODO: fix shell change
#RUN chsh -s /bin/zsh ctfuser

RUN git clone https://github.com/greganderson/terminal-ctf.git /home/ctfuser/challenges && \
    echo "Skip cache: $(date +%s)" > /dev/null

# for some reason wont start without this (ssh hostkey not found)
USER root
