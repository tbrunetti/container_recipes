# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get rsem working
## rsem has dependencies of c++, perl, perl-doc, and r
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget python3 build-essential perl-doc r-base bc && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# download and unzip precompiled binary
RUN cd /opt/ && \
    wget https://github.com/deweylab/RSEM/archive/refs/tags/v1.3.3.tar.gz && \
    tar -zxvf v1.3.3.tar.gz && \
    rm -rf v1.3.3.tar.gz

## making all rsem commands executable! (or else you get a really weird error)
RUN cd /opt/RSEM-1.3.3/ && \
    make
    ## make install ##can remove this bc it only adds executables to usr/local/bin/

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

# add rsem executable for arch to path
ENV PATH="$PATH:/opt/RSEM-1.3.3/:/opt/miniforge3/bin"
