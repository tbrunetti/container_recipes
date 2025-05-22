# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get bbmap working
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget python3 default-jre default-jdk && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# download and unzip precompiled binary
RUN cd /opt/ && \
    wget https://sourceforge.net/projects/bbmap/files/BBMap_39.08.tar.gz/download && \
    tar -zxvf download && \
    rm -rf download # clean up to reduce container size

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

# add scripts in bbmap to path
ENV PATH="$PATH:/opt/bbmap/:/opt/miniforge3/bin"
