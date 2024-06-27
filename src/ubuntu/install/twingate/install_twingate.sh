#!/usr/bin/env bash
set -ex


### Install Twingate
RUN apt-get update && echo "deb [trusted=yes] https://packages.twingate.com/apt/ /" | tee /etc/apt/sources.list.d/twingate.list && \
    apt-get update -o Dir::Etc::sourcelist="sources.list.d/twingate.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" && \
    apt install -yq twingate
COPY ./src/ubuntu/install/twingate/tgfiles /etc/twingate
COPY ./src/ubuntu/install/twingate/auth_files /var/lib/twingate
COPY ./src/ubuntu/install/twingate/custom_startup.sh $STARTUPDIR/custom_startup.sh
COPY ./src/ubuntu/install/twingate/twingate_init.sh $STARTUPDIR/twingate_init.sh
RUN chmod +x $STARTUPDIR/twingate_init.sh && \
    chmod +x $STARTUPDIR/custom_startup.sh && \
    # echo "kasm-user ALL= NOPASSWD: /usr/bin/twingate" >> /etc/sudoers && \
    echo "kasm-user ALL=(ALL) NOPASSWD: /dockerstartup/twingate_init.sh" >> /etc/sudoers
RUN echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers