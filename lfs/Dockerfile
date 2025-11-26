FROM debian:12

RUN apt update          && \
    apt upgrade -y      && \
    apt install -y build-essential bison gawk wget file texinfo

ENTRYPOINT bash