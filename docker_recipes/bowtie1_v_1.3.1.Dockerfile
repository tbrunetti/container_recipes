# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# initial OS library and certificate updates
RUN apt-get update && \
    apt-get install -y unzip wget python3 && \
    rm -rf /var/lib/apt/lists/* # clean up to reduce image size

# download precompiled binary into /opt directory
RUN cd /opt && \
    wget "https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.3.1/bowtie-1.3.1-linux-$(uname -m).zip/download"

# unzip the downloaded precompiled binary
## attempting to rename bowtie1 directory so I can add it to my path with no issues (docker doesn't execute bash commands in ENV)
RUN cd /opt && \
    unzip download && \
    rm -rf download && \
    mv /opt/bowtie-1.3.1-linux-$(uname -m)/ /opt/bowtie1-1.3.1/ # to save image space since already decompressed

# add binary location to path
# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

ENV PATH="$PATH:/opt/bowtie1-1.3.1/:/opt/miniforge3/bin"
