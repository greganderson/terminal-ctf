FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
	python3 \
	curl \
	vim \
    man man-db \
    unminimize \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN yes | unminimize

WORKDIR /ctf

COPY ./challenges /ctf/challenges
COPY ./check/target/release/check /usr/bin/check

COPY ./touch ./.tools/touch
COPY ./touch.1 ./.tools/touch.1

CMD ["/bin/bash"]
