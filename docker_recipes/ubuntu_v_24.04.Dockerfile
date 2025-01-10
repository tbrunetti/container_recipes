# base of Docker image is Ubuntu version 24.04
# mostly built to keep a stable version of bash/shell 
FROM ubuntu:24.04

# update OS libraries and install OS dependencies to get FastQC working
RUN apt-get update &&  \
    apt-get install -y unzip wget perl default-jre default-jdk && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size
