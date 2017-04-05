# Cosanlab Singularity Analysis Container

This is a Singularity spec file that can be used to build a container and run on Dartmouth's [Discovery](http://techdoc.dartmouth.edu/discovery/) HPC cluster. It is a Docker -> Singularity bootstrap of our [analysis container](https://github.com/cosanlab/cosanToolsDocker)

You can either:  

1. Copy the built singularity image from Discovery, located at /ihome/ejolly
2. Build/modify the container from scratch

### Building a container from scratch with this repo
You'll need a local machine with sudo privileges and singularity installed. If you're running OSX you can follow the directions [here](http://singularity.lbl.gov/install-mac) to get a vagrant VM running to do this. Then proceed with:
```
#on your local machine with sudo privileges
sudo singularity create --size 8000 myContainer.img

#Singularity in the command below is the spec file in this repo, adjust path accordingly
sudo singularity bootstrap myContainer.img Singularity

#You might need to copy the .img out of your vagrant vm first if you're using one; by default /vagrant is shared with your host OS
scp myContainer.img user@discovery.dartmouth.edu:~


#on discovery, from ~
module load singularity
singularity run myContainer.img

#OR
singularity exec ./myContainer.img someCommand

#to mount a folder with data
singularity exec -B /path/to/data:/mnt ./myContainer someCommand
```