FROM ubuntu:24.04

## fastq-screen has perl and bowtie2 dependencies 
RUN apt-get update && \
    apt-get install -y unzip wget perl software-properties-common python3 && \
    rm -rf /var/lib/apt/lists/*  ##clean up to reduce image size

## download and install bowtie2 v2.5.4 (same version as conda install)
RUN cd /opt/ && \
    wget "https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.5.4/bowtie2-2.5.4-linux-$(uname -m).zip/download" && \
    unzip download && \
    rm -rf download && \
    mv /opt/bowtie2-2.5.4-linux-$(uname -m)/ /opt/bowtie2-2.5.4/ ##rename to avoid issues with adding to path

## download and unzip precompiled library for fastq-screen
RUN cd /opt/ && \
    wget "https://github.com/StevenWingett/FastQ-Screen/archive/refs/tags/v0.16.0.tar.gz" && \
    tar -zxvf v0.16.0.tar.gz && \
    rm -rf v0.16.0.tar.gz && \
    mv /opt/FastQ-Screen-0.16.0/ /opt/fastq_screen/ ##change name to generic fastq_screen

## install miniforge due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

## add fastq-screen, bowtie2, and miniforge to path 
ENV PATH="$PATH:/opt/fastq_screen/:/opt/bowtie2-2.5.4/:/opt/miniforge3/bin"