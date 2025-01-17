## using prebuilt miniforge image 
## may want to figure out how to reduce the size of the image
FROM condaforge/mambaforge

## copying r_env.yml file into image
COPY r_env.yml r_env.yml

## installing r/python packages needed via miniforge
RUN conda env create -f r_env.yml
## adding command to .bashrc to automatically activate created env when image is opened
RUN echo "source activate r_env_crispr" > ~/.bashrc

## directing path to env bin when image is opened
ENV PATH=/opt/conda/envs/r_env_crispr/bin:$PATH

