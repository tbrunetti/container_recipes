# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04

# initial OS library and certificate updates
RUN apt-get update && \
    apt-get install -y software-properties-common wget

# add python repo
RUN add-apt-repository ppa:deadsnakes/ppa

# update OS libraries and certificates after python repo added and install python
RUN apt-get update &&  \
    apt-get install -y unzip python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# install multiqc
# --break-system-packages is not good practice but b/c the only sotware in
# this docker container is multiqc, ok with doing it just to install
# package globally and bypass a virutal env
RUN pip3 install --no-cache-dir --break-system-packages multiqc==1.26

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-Linux-x86_64.sh && \
    chmod a+x Miniforge3-24.11.3-2-Linux-x86_64.sh && \
    bash Miniforge3-24.11.3-2-Linux-x86_64.sh -b # install in batch mode so not prompted for user input

# add fastqc executable to path
ENV PATH="$PATH:/root/miniforge3/bin"
