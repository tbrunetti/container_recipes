# syntax=docker/dockerfile:1.4

##################################################
####### MULTI-BUILD STAGE 1: Cache builder #######
##################################################

# base of Docker image is Ubuntu version 24.04
FROM ubuntu:24.04 AS builder

# update OS libraries and install OS dependencies to get rsem working
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget curl python3 build-essential default-jre default-jdk gfortran \
    zlib1g-dev libbz2-dev liblzma-dev libcurl4-openssl-dev libssl-dev libncurses-dev \
    libreadline-dev libpcre2-dev libcairo2-dev libtiff-dev libpng-dev libicu-dev \
    libharfbuzz-dev libfribidi-dev libxml2-dev libgsl-dev libmagick++-dev libgmp-dev cmake \
    gdal-bin libgdal-dev libsodium-dev libudunits2-dev libudunits2-dev libfftw3-dev && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size


# Avoid memory errors
ENV R_MAKEVARS_USER=/etc/R/Makevars
RUN mkdir -p /etc/R && echo "MAKEFLAGS=-j3" >> /etc/R/Makevars


# download and decompress R source code
RUN cd /opt/ && \
    export R_VERSION=4.4.2 && \
    curl -O https://cran.rstudio.com/src/base/R-4/R-${R_VERSION}.tar.gz && \
    tar -xzvf R-${R_VERSION}.tar.gz && \
    rm -rf R-${R_VERSION}.tar.gz


# configure R install and compile
RUN export R_VERSION=4.4.2 && \
    cd /opt/R-${R_VERSION} && \
    ./configure --prefix=/opt/R-${R_VERSION}/ --enable-R-shlib --enable-memory-profiling --with-blas --with-lapack --with-cairo --with-libpng --with-libtiff --with-jpeglib && \
    make

# put R executable in PATH
ENV PATH="$PATH:/opt/R-4.4.2/bin/"

# Avoid memory errors when installing packages within R
ENV OMP_NUM_THREADS=3
ENV OPENBLAS_NUM_THREADS=3
ENV MKL_NUM_THREADS=3

# install renv so can build version controlled packages from lock file
RUN Rscript -e "install.packages('renv', version = '1.1.5', repos = 'https://cloud.r-project.org')"

# copy lock file into container at a directory within container called /projects
# rename to be renv.lock as that is the default lock name restore() is looking for
# cpp11 manually change verison to 0.5.0, ggplot2 manually change 3.5.2
WORKDIR /projects
COPY 2025-08-18_im_super4_all_R_libraries_locked_renv.lock renv.lock

# some installs require a github token
# for security reasons, this should be passed as an argument at runtime
ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}
RUN echo "GITHUB_PAT=${GITHUB_PAT}" >> /root/.Renviron

# set cache for renv so failed builds don't have to keep downloading same packages again
ENV RENV_PATHS_CACHE=/renv/cache
ENV RENV_PATHS_ROOT=/renv/cache

# Download all packages using renv lock file but do not install
# store downloads in cache
# helps with troubleshooting; do not have to download all packages again
RUN --mount=type=cache,target=/renv/cache,mode=0755 \
    mkdir -p /projects/renv/library && \
    Rscript --no-save --no-restore -e "\
        renv::consent(provided = TRUE); \
        Sys.setenv(RENV_PATHS_ROOT = '/renv/cache'); \
        Sys.setenv(RENV_PATHS_CACHE = '/renv/cache'); \
        Sys.setenv(RENV_PATHS_LIBRARY = '/projects/renv/library'); \
        options(renv.verbose = TRUE); \
        renv::restore(lockfile = '/projects/renv.lock', clean = FALSE, transactional = FALSE); \
        cat('== Done restoring ==\\n');"


##################################################
####### MULTI-BUILD STAGE 2: Final image  ########
##################################################

FROM ubuntu:24.04

# Reinstall system dependencies from step 1
RUN apt-get update &&  \
    apt-get install -y unzip gzip wget curl python3 build-essential default-jre default-jdk gfortran \
    zlib1g-dev libbz2-dev liblzma-dev libcurl4-openssl-dev libssl-dev libncurses-dev \
    libreadline-dev libpcre2-dev libcairo2-dev libtiff-dev libpng-dev libicu-dev \
    libharfbuzz-dev libfribidi-dev libxml2-dev libgsl-dev libmagick++-dev libgmp-dev cmake \
    gdal-bin libgdal-dev libsodium-dev libudunits2-dev libudunits2-dev libfftw3-dev && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Avoid memory errors
ENV R_MAKEVARS_USER=/etc/R/Makevars
RUN mkdir -p /etc/R && echo "MAKEFLAGS=-j3" >> /etc/R/Makevars

# Copy the builder stage to current stage build
COPY --from=builder /opt/R-4.4.2 /opt/R-4.4.2
ENV PATH="/opt/R-4.4.2/bin/:$PATH"

# Copy renv cache and WORKDIR from stage 1 build
COPY --from=builder /projects/renv /projects/renv
COPY --from=builder /projects/renv.lock /projects/renv.lock

WORKDIR /projects

# some installs require a github token
# for security reasons, this should be passed as an argument at runtime
ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}
RUN echo "GITHUB_PAT=${GITHUB_PAT}" >> /root/.Renviron

# Avoid memory errors when installing packages within R
ENV OMP_NUM_THREADS=3
ENV OPENBLAS_NUM_THREADS=3
ENV MKL_NUM_THREADS=3

# set cache for renv so failed builds don't have to keep downloading same pa
ENV RENV_PATHS_CACHE=/renv/cache
ENV RENV_PATHS_LIBRARY=/projects/renv/library

# install conda due to dependancy bug in snakemake but will not be used for installing software
RUN cd /opt/ && \
    wget "https://github.com/conda-forge/miniforge/releases/download/24.11.3-2/Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh" && \
    chmod a+x Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh && \
    bash Miniforge3-24.11.3-2-$(uname)-$(uname -m).sh -b -p /opt/miniforge3 # install in batch mode so not prompted for user input

# add miniforge and base R directory to path
ENV PATH="$PATH:/opt/R-4.4.2/:/opt/miniforge3/bin"
