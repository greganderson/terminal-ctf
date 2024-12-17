FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
	python3 \
	curl \
	vim \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /ctf

COPY challenges /ctf/challenges

CMD ["/bin/bash"]
