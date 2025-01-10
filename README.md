# container recipes
A repository of container recipes for software reproducibility  

## docker_recipes  
Contain `.Dockerfile` files that can be downloaded and used to build a container on your local computer.  
</br>  
**To build containers from the dockerfile, you can run:**
```
sudo docker build -f nameOf.Dockerfile . --tag nameOfContainer
```  

These containers are also pre-compiled and built on my dockerhub for immediate use.  
<br/>  
**To download a pre-built and pre-compiled container:**
For example, if you wanted to pull down a copy of the `fastqc_v_0.12.1` container, you can run:  

```
sudo docker pull tbrunetti/functional_crispr_screen:fastqc-v0.12.1
```

Containers can run the software that is containerize by calling the container and executable you want to use.  
<br/>  
For example, if you wanted to **run fastqc from the software container on files that live on your local computer (not withiin the container)**, using the `fastqc_v_0.12.1` container build, you can do the following (in this case it will pull up the help page):  
> [!IMPORTANT] 
> The command below will only work if you have either (a) already built the container from a dockerfile first using the build command above, or (b) downloaded the pre-built/pre-compiled container using the pull command above.  
```
sudo docker run tbrunetti/functional_crispr_screen:fastqc-v0.12.1 fastqc -h
```

You can also **run commands _within_ the container interactively, which is a must less common use case.**  
<br/>  
However, to do this, you can run:  
```
sudo docker run -it tbrunetti/functional_crispr_screen:fastqc-v0.12.1
```
When you do this, you notice your command prompt, now will change to something similar to the following to show you are __inside__ the container:  
```
root@d34588857913:/#
```
To can now run fastqc from here or any shell/bash command that is supported within the context of the container:  
```
fastqc -h
```
Here is an example of some trucated output that this would print out:  
```
            FastQC - A high throughput sequence QC analysis tool

SYNOPSIS

	fastqc seqfile1 seqfile2 .. seqfileN

    fastqc [-o output dir] [--(no)extract] [-f fastq|bam|sam] 
           [-c contaminant file] seqfile1 .. seqfileN

DESCRIPTION

    FastQC reads a set of sequence files and produces from each one a quality
    control report consisting of a number of different modules, each one of 
    which will help to identify a different potential type of problem in your
    data.
```   
Additionally, you can run shell/bash commands and it would use the container's OS and variables:
```
echo ${PATH}
```
Would output:  
```
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/FastQC/
```
> [!IMPORTANT]
> The `echo ${PATH}` output is based on the container and its OS.  Not your own local computer!!  

**To exit an interactive container session, just type exit:**  
```
exit
```
This will exit the container and return you back to your own local OS command prompt.  
<br/>  

## Not sure which images you have build or downloaded?  
You can run the following:  
```
sudo docker images
```
This will list all docker images you have available on your local OS.  


## Containers in Docker Hub Repos  

* _tbrunetti/functional_crispr_screen_  
    * fastqc-v0.12.1  
    * multiqc-v1.16  
    * cutadapt-v4.2  
    * bowtie1-v1.3.1   


