# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# initial OS library and certificate updates
RUN apt-get update && \
    apt-get install -y unzip wget perl software-properties-common python3 && \
    rm -rf /var/lib/apt/lists/* # clean up to reduce image size

## download and install bowtie2 v2.5.4 (same version as conda install)
RUN cd /opt/ && \
    wget "https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.5.4/bowtie2-2.5.4-linux-$(uname -m).zip/download" && \
    unzip download && \
    rm -rf download && \
    mv /opt/bowtie2-2.5.4-linux-$(uname -m)/ /opt/bowtie2-2.5.4/ ##rename to avoid issues with adding to path

# add binary location to path
# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

ENV PATH="$PATH:/opt/bowtie2-2.5.4/:/opt/miniforge3/bin"
