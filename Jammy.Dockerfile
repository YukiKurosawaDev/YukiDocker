FROM ubuntu:jammy

LABEL MAINTAINER="YukiKurosawaDev"
COPY apt.sh /apt.sh
RUN /apt.sh/updatepkg.sh
ENTRYPOINT [ "/bin/bash" ]