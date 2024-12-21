FROM ubuntu:22.04
USER root
WORKDIR /home/root
RUN apt update -y && apt install -y \
    s3fs \
    fuse \
    wget \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

ENTRYPOINT ["/opt/startup.sh"]
