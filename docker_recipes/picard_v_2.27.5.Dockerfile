# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get picard working
## picard has dependencies of jdk, r, and python
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget python3 build-essential default-jdk r-base && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# download and unzip precompiled binary
RUN cd /opt/ && \
    wget https://github.com/broadinstitute/picard/archive/refs/tags/2.27.5.tar.gz && \
    tar -zxvf 2.27.5.tar.gz && \
    rm -rf 2.27.5.tar.gz

## download picard.jar file and place it in the picard-2.27.5 directory
## cant have anything under root or else others cant access them while running container
RUN cd /opt/picard-2.27.5/ && \
    wget https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

# add picard executable for arch to path - idk if this is needed since it was executable without it but doing to be safe 
ENV PATH="$PATH:/opt/picard-2.27.5/:/opt/miniforge3/bin"
