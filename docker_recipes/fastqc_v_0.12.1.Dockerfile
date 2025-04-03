# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get FastQC working
RUN apt-get update &&  \
    apt-get install -y unzip wget perl default-jre default-jdk && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-Linux-x86_64.sh && \
    chmod a+x Miniforge3-24.11.3-2-Linux-x86_64.sh && \
    bash Miniforge3-24.11.3-2-Linux-x86_64.sh -b # install in batch mode so not prompted for user input

# download and unzip precompiled binary
RUN cd /opt/ && \
    wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
    unzip fastqc_v0.12.1.zip && \
    rm -rf fastqc_v0.12.1.zip

# add fastqc executable to path
ENV PATH="$PATH:/opt/FastQC/:/root/miniforge3/bin"
