FROM ubuntu:jammy

LABEL MAINTAINER="YukiKurosawaDev"

# DEFINE PORTS
## POSTGRESQL
EXPOSE 5432 
## NGINX
EXPOSE 80
EXPOSE 443

# TZDATA CONFIGURATIONS
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# PACKAGE CONFIGURATIONS
COPY apt.sh /apt.sh
RUN /apt.sh/updatepkg.sh
COPY dak.sh /dak.sh
RUN /dak.sh/install.sh
RUN /dak.sh/configure.sh

# IMAGE ENTRY
ENTRYPOINT [ "/dak.sh/start.sh" ]