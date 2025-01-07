# container recipes
A repository of container recipes for software reproducibility  

## docker_recipes  
Contain `.Dockerfile` files that can be downloaded and used to build a container on your local computer.  To build these files, you can run:  
```
sudo docker build -f nameOf.Dockerfile . --tag nameOfContainer
```  

These containers are also pre-compiled and built on my dockerhub for immediate use.  For example, if you wanted to pull down a copy of the `fastqc_v_0.12.1` container, you can run:  

```
sudo docker pull tbrunetti/functional_crispr_screen:fastqc-v0.12.1
```

## Containers in Docker Hub Repos  

* _tbrunetti/functional_crispr_screen_  
    * fastqc-v0.12.1  
    * multiqc-v1.16  
    * cutadapt-v4.2  
    * bowtie1-v1.3.1   


