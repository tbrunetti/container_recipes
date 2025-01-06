# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get FastQC working
RUN apt-get update &&  \
    apt-get install -y unzip wget perl default-jre default-jdk && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# download and unzip precompiled binary
RUN cd /opt/ && wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && unzip fastqc_v0.12.1.zip

# add fastqc executable to path
ENV PATH "$PATH:/opt/FastQC/"
