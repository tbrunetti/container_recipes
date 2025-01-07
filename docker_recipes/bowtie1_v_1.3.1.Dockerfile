# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# initial OS library and certificate updates
RUN apt-get update && \
    apt-get install -y unzip wget python3 && \
    rm -rf /var/lib/apt/lists/* # clean up to reduce image size

# download precompiled binary into /opt directory
RUN cd /opt && \
    wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.3.1/bowtie-1.3.1-linux-x86_64.zip/download

# unzip the downloaded precompiled binary
RUN cd /opt && \
    unzip download && \
    rm -rf download # to save image space since already decompressed

# add binary location to path
ENV PATH "$PATH:/opt/bowtie-1.3.1-linux-x86_64/"
