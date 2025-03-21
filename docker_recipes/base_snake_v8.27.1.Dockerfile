FROM condaforge/miniforge3:latest

## copying base_snake_env.yml file into image
COPY copy_files/base_snake_env.yml base_snake_env.yml

## installing r/python packages needed via miniforge
RUN conda env create -f base_snake_env.yml
## adding command to .bashrc to automatically activate created env when image is opened
RUN echo "source activate base_snake" > ~/.bashrc

## directing path to env bin when image is opened
ENV PATH=/opt/conda/envs/base_snake/bin:$PATH