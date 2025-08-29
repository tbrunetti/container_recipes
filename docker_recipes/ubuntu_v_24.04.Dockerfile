# base of Docker image is Ubuntu version 24.04
# mostly built to keep a stable version of bash/shell 
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get FastQC working
RUN apt-get update &&  \
    apt-get install -y unzip wget perl default-jre default-jdk && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

ENV PATH="$PATH:/opt/miniforge3/bin"