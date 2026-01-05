# base of Docker image is Ubuntu version 24.04
# mostly built to keep a stable version of bash/shell 
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get FastQC working
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget perl vim default-jre default-jdk less software-properties-common build-essential && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

## download and unzip precompiled binary for samtools
RUN cd /opt/ && \
    wget "https://github.com/samtools/samtools/releases/download/1.23/samtools-1.23.tar.bz2" && \
    tar -xvjf samtools-1.23.tar.bz2 && \
    rm -rf samtools-1.23.tar.bz2

## install dependencies for samtools build
RUN apt-get update && \
    apt-get install -y libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev && \
    rm -rf /var/lib/apt/lists/*

## do i need to compile this??
RUN cd /opt/samtools-1.23/ && \
    ./configure --prefix=/opt/samtools-1.23/ && \
    make && \
    make install

## add samtools to path
ENV PATH="$PATH:/opt/samtools-1.23/bin/"