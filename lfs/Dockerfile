FROM debian:12

RUN apt update          && \
    apt upgrade -y      && \
    apt install -y build-essential bison gawk wget file texinfo python3 sudo

# /bin/sh must point to bash
RUN rm /bin/sh && ln -s /usr/bin/bash /bin/sh

# Configure environment
ENV LFS=/mnt/lfs
RUN mkdir -p $LFS/scripts $LFS/log $LFS/config /tmp/sources

# Run system check
COPY scripts/ch1/ $LFS/scripts/ch1/
RUN $LFS/scripts/ch1/run-ch1-version-check.sh

# Download sources into image
COPY scripts/common.sh $LFS/scripts/common.sh
COPY scripts/ch3/ $LFS/scripts/ch3/
COPY sources/ /tmp/sources/
RUN $LFS/scripts/ch3/run-ch3-get-sources.sh

# Prepare the environment
COPY scripts/ch4/ $LFS/scripts/ch4/
RUN $LFS/scripts/ch4/run-ch4-all.sh

# Remove default bashrc to avoid problems when building LFS packages
RUN [ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

# Copy over the rest of the needed files
COPY ./scripts $LFS/scripts/
COPY ./config $LFS/config/

USER lfs
WORKDIR $LFS

CMD ["bash", "-c", "$LFS/scripts/run-all.sh"]
