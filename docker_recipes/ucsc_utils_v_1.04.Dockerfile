# base of Docker image is Ubuntu version 24.04
# mostly built to keep a stable version of bash/shell 
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get FastQC working
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget python3 vim default-jre default-jdk less rsync && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

## downloading ucsc utils precompiled binaries
## does this only have support for linux x86_64??
RUN cd /opt/ && \
    rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ ./ucsc_utils/ 

## add ucsc utils to path
ENV PATH="$PATH:/opt/ucsc_utils/"

