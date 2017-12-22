# Cosanlab Singularity Analysis Container

This is a Singularity spec file that can be used to build a container and run on Dartmouth's [Discovery](http://techdoc.dartmouth.edu/discovery/) HPC cluster. It is a Docker -> Singularity bootstrap of our [analysis container](https://github.com/cosanlab/cosanToolsDocker)

This container has been built a bit **differently** than the container on the the [main branch](https://github.com/cosanlab/cosanToolsSingularity/tree/master). Specifically its conda-based python environment is *editable* despite the container being read-only.

Location on Dartmouth's discovery cluster: `/dartfs/rc/lab/D/DBIC/cosanlab/Resources/cosanTools`

**Critical**  
If moving this container elsewhere, make sure to copy the `container_pkgs` folder as well! This is the externally mounted location where all the complete conda environment is installed.

### Building a container from scratch with this repo
You'll need a local machine with sudo privileges and singularity installed. If you're running OSX you can follow the directions [here](http://singularity.lbl.gov/install-mac) to get a vagrant VM running to do this. Then proceed with:  

```
#on your local machine with sudo privileges
sudo singularity create --size 8000 cosanTools.img

#Singularity in the command below is the spec file in this repo, adjust path accordingly
sudo singularity bootstrap cosanTools.img Singularity

#Create a container_pkgs folder at the same location as the container image to store the editable environment
mkdir container_pkgs

#Copy the setup_container.sh script in this repo within that folder
mv setup_container.sh container_pkgs/

#Run this additional bash script to create the environment and install basic python packages within it (no need to use sudo here)
singularity exec --writable -B ./container_pkgs/:/container_pkgs cosanTools.img /container_pkgs/setup_container.sh

#Make sure to ALWAYS run this container with the container_pkgs folder mounted
singularity run -B ./container_pkgs:/container_pkgs cosanTools.img
```
