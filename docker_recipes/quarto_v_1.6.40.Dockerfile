# base of Docker image is Ubuntu version 24.04
# mostly built to keep a stable version of bash/shell 
FROM ubuntu:24.04

## initial OS library and certificate updates
RUN apt-get update && \
    apt-get install -y software-properties-common 

## adding python repo
RUN add-apt-repository ppa:deadsnakes/ppa

## installing r-base, r-knitr, r-rmarkdown, python3, and pip3
RUN apt-get update &&  \
    apt-get install -y --no-install-recommends build-essential r-base r-cran-knitr r-cran-rmarkdown python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

## installing jupyter
RUN pip3 install --no-cache-dir --break-system-packages jupyter

# update OS libraries and install OS dependencies to get quarto working
RUN apt-get update &&  \
    apt-get install -y wget default-jre default-jdk gdebi-core && \
    rm -rf /var/lib/apt/lists/* 

## pulling buildx global variable of the target arch of the image
## bc uname -m doesnt work for quarto arm64 (their file is named linux-arm64 and not linux-aarch64)
## have to call it as an ARG here before you can use it in RUN commands
ARG TARGETARCH

## installing quarto CLI since dependencies have already been installed 
RUN cd /opt/ && \
    wget "https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-$TARGETARCH.deb" && \
    gdebi --non-interactive quarto-1.6.40-linux-$TARGETARCH.deb 
