FROM condaforge/miniforge3:latest

## copying r_env.yml file into image
COPY copy_files/fastqc_env.yml fastqc_env.yml

## installing r/python packages needed via miniforge
RUN conda env create -f fastqc_env.yml
## adding command to .bashrc to automatically activate created env when image is opened
RUN echo "source activate fastqc_v0.12.1" > ~/.bashrc

## directing path to env bin when image is opened
ENV PATH=/opt/conda/envs/fastqc_v0.12.1/bin:$PATH