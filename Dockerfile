FROM ubuntu:jammy

LABEL MAINTAINER="YukiKurosawaDev"
COPY sources.list /etc/apt/sources.list1
RUN apt update && apt upgrade -y && apt install ca-certificates -y && apt autoremove -y && apt clean && rm -rvf /var/lib/apt/lists/* && \
rm -vf /etc/apt/sources.list && mv /etc/apt/sources.list1 /etc/apt/sources.list && \
apt update && apt upgrade -y && apt autoremove -y && apt clean && rm -rvf /var/lib/apt/lists/*
ENTRYPOINT [ "/bin/bash" ]