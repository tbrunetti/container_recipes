# container recipes
A repository of container recipes for software reproducibility

## docker_recipes
Contain `.Dockerfile` files that can be downloaded and used to build a container on your local computer.
</br>

## Container Commands and Usage

**To build containers from the dockerfile, you can run:**
```
sudo docker build -f nameOf.Dockerfile . --tag nameOfContainer
```
<br/>
<br/>

These containers are also pre-compiled and built on my dockerhub for immediate use.

**To build and push containers to dockerhub**

Make sure you name your container in a way that directs it to the proper dockerhub repo.

```
sudo docker build -f nameOf.Dockerfile . --tag user/repo:nameOfContainer
```
<br/>
<br/>

You can then push it to a dockerhub repo like so:
```
sudo docker push user/repo:nameOfContainer
```
<br/>
<br/>

**To download a pre-built and pre-compiled container:**
For example, if you wanted to pull down a copy of the `fastqc_v_0.12.1` container, you can run:

```
sudo docker pull tbrunetti/functional_crispr_screen:fastqc-v0.12.1
```
<br/>
<br/>

Containers can run the software that is containerize by calling the container and executable you want to use.
For example, if you wanted to **run fastqc from the software container on files that live on your local computer (not within the container)**, using the `fastqc_v_0.12.1` container build, you can do the following (in this case it will pull up the help page):
> [!IMPORTANT]
> The command below will only work if you have either (a) already built the container from a dockerfile first using the build command above, or (b) downloaded the pre-built/pre-compiled container using the pull command above.


```
sudo docker run tbrunetti/functional_crispr_screen:fastqc-v0.12.1 fastqc -h
```

<br/>
<br/>

You can also **run commands _within_ the container interactively, which is a must less common use case.**
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

* [_tbrunetti/functional_crispr_screen_](https://hub.docker.com/r/tbrunetti/functional_crispr_screen/tags)
    * ubuntu-v24.04
    * fastqc-v0.12.1
    * multiqc-v1.16
    * cutadapt-v4.2
    * bowtie1-v1.3.1
    * bbmap-v39.08
    * quarto-v1.6.40
    * r_env_crispr-v4.3.3

* [_madiapgar/bulk_rna_seq_](https://hub.docker.com/r/madiapgar/bulk_rna_seq/tags)
    * fastqc-v0.12.1
    * star-v2.7.10b (linux/amd64 only!!)
    * multiqc-v1.26
    * cutadapt-v4.2
    * rsem-v1.3.3
    * picard-v2.27.5

* [_madiapgar/shotgun_meta_](https://hub.docker.com/repository/docker/madiapgar/shotgun_meta/tags)
    * fastqc-v0.12.1
    * multiqc-v1.26
    * bbmap-v39.08
    * humann-v3.9 *(includes metaphlan v4.0.3)*

* [_tbrunetti/immu6110_introduction_to_bioinformatics_](https://hub.docker.com/repository/docker/tbrunetti/immu6110_introduction_to_bioinformatics/tags)
   * imsuper4_freeze_2025-08-13_r_v_4.4.2 (see ADVANCED! section for more info on this build)
   * v02.2022
   * v01.2022

## ADVANCED!

**To build multi-platform containers**

You will need to enable your [docker environment to build multi-platform containers](https://docs.docker.com/build/building/multi-platform/#build-multi-platform-images). Once you have done so, you can build your container on multiple platforms and push it to the dockerhub repo all in the same command.

```
sudo docker buildx build \
--push \
--platform linux/amd64,linux/arm64 \ ## whatever platforms you want it built on
-f nameOf.Dockerfile \
--tag user/repo:nameOfContainer .
```

Building multi-platform containers takes up a lot of space, make sure to continually clear your cache so you don't get any "not enough free disk space" errors from docker. You can do this by running the command below.

```
sudo docker system prune -a
```

**To create a bind point to a docker container**

To run commands in a pre-built container that require local files, you'll need to [specify a bind point](https://docs.docker.com/engine/storage/bind-mounts/). You'll notice that the `--mount` flag requires three inputs (separated by commas); `type`, `src`, and `target`.
* `type`: is the kind of mount you would like to do to the docker container. In this case, we want a bind point to the local system, so `type=bind`.
* `src`: is the location of a file/directory on the host (i.e. what local files you want run in the container) and can be an absolute or relative path (can use `src=.` or `src="$(pwd)"` as well).
* `target`: is the location where the file/directory is mounted in the container and _MUST_ be an absolute path.

```
sudo docker run --mount type=bind,src=/my_local/directory/,target=/directory/ \
user/repo:nameOfContainer \
command --file directory/sub_directory/local_file.txt
```

**Rebuilding imsuper4_freeze_2025-08-13_r_v_4.4.2**

The container image is a version controlled freeze of R v4.4.2 and all associated R packages (~650 different R packages) on the Department of Immunology & Microbiology imsuper4 compute node as of August 13, 2025.  This DockerFile and generated image are a complicated and due to the nature of using `renv` with nearly 650 version controlled packges for R v4.4.2, it encounters many random seg faults during the builder stage that are not reproducible.  Therefore, an renv cache is generated within the builder stage of the container so that at each failure, the build can be re-run from point of failure without having to download packages again or re-install any packages that were sucessfully installed previously.  This build does require the associated renv lock file, located in the [copy_files](https://github.com/tbrunetti/container_recipes/tree/blaze/copy_files) directory of this repo and is called, `2025-08-11_im_super4_all_R_libraries_locked_renv.lock`.

 > [!IMPORTANT]
 > Make sure you are not connected to campus VPN to build this; with the vast number of calls to different R repositories the VPN slows down access to the these repositories that the build will fail.

 1. First download the DockerFile and associated lock file above.  Be sure to build the container in the same directory as the location of the lock file as that needs to by copied into the Docker container build.
 2. Run the following command but replace the `ghp_XXXXXXXXXXXXXX` with your associated github token:
 ```
 sudo DOCKER_BUILDKIT=1 docker build --progress=plain --build-arg GITHUB_PAT=ghp_XXXXXXXXXXXXXX -f ../docker_recipes/imsuper4_freeze_2025-08-13_r_v_4.4.2.Dockerfile . --tag tbrunetti/immu6110_introduction_to_bioinformatics:imsuper4_freeze_2025-08-13_r_v_4.4.2
```
3. Re-run the above command if you encounter seg faults or memory mapping issues.  It should resume from point of failure and use the renv cache so that downloads and successful installs are not repeated.
