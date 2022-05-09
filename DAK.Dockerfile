FROM ubuntu:jammy

LABEL MAINTAINER="YukiKurosawaDev"
COPY apt.sh /apt.sh
RUN /apt.sh/updatepkg.sh
COPY dak.sh /dak.sh
RUN /dak.sh/install.sh
ENTRYPOINT [ "/dak.sh/start.sh" ]