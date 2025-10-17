# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get star working
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget python3 build-essential bc perl-doc && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# download and unzip precompiled binary
# compiling binary rn but couldn't get precompiled executable to work
RUN cd /opt/ && \
    wget https://github.com/alexdobin/STAR/archive/2.7.11b.tar.gz && \
    tar -zxvf 2.7.11b.tar.gz && \
    rm -rf 2.7.11b.tar.gz

# compiling binary rn but couldn't get precompiled executable to work
    #cd STAR-2.7.10b/source/ && \
    #make STAR

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

# add star executable for arch to path
## need to figure out how to make this work w arm64 since they don't have it precompiled for arm64
ENV PATH="$PATH:/opt/STAR-2.7.11b/bin/Linux_x86_64/:/opt/miniforge3/bin"
