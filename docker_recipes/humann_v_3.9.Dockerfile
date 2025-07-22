# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get humann working
## humann has dependencies of python3 and python3-setuptools
RUN apt-get update &&  \
    apt-get install -y software-properties-common unzip gzip wget python3 python3-setuptools python3-pip build-essential && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# download and unzip precompiled binary
RUN cd /opt/ && \
    wget https://files.pythonhosted.org/packages/b2/8f/0d908a2a43f89f03e4d1f22baf80b77a4bce342b721552737173c4da74cd/humann-3.9.tar.gz && \
    tar -zxvf humann-3.9.tar.gz && \
    rm -rf humann-3.9.tar.gz

## actually install humann
RUN cd /opt/humann-3.9/ && \
    python3 setup.py install

## install metaphlan v4.0.3 via pip 
RUN pip3 install --no-cache-dir --break-system-packages metaphlan==4.0.3

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

# adding humann executable to global path
ENV PATH="$PATH:/opt/humann-3.9/:/opt/miniforge3/bin"