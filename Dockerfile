FROM debian:11

EXPOSE 42420

# Variables
ARG VERSION=1.20.4
ARG FILENAME=vs_server_linux-x64_${VERSION}.tar.gz
ARG USERNAME=vintagestory
ARG VSPATH=/home/vintagestory/server
ARG DATAPATH=/var/vintagestory/data

# Install dependencies in single layer to reduce image size
RUN apt-get update -q -y && \
    apt-get install -yf \
    screen wget curl vim \
    procps && \
    wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y aspnetcore-runtime-7.0

# Create user and directories
RUN useradd -ms /bin/bash ${USERNAME} && \
    mkdir -p ${VSPATH} ${DATAPATH} && \
    chown -R ${USERNAME}:${USERNAME} ${VSPATH} ${DATAPATH}

# Server setup
WORKDIR ${VSPATH}
RUN wget https://cdn.vintagestory.at/gamefiles/stable/${FILENAME} && \
    tar xzf ${FILENAME} && \
    rm ${FILENAME}

# Copy and set permissions for launcher
RUN wget -O ${VSPATH}/launcher.sh https://raw.githubusercontent.com/jgniecki/Vintage-Story-Server/${VERSION}/launcher.sh
RUN chown ${USERNAME}:${USERNAME} ${VSPATH}/launcher.sh && \
    chmod +x ${VSPATH}/launcher.sh ${VSPATH}/server.sh

USER ${USERNAME}

ENTRYPOINT [ "./launcher.sh" ]