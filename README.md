# Cosanlab Singularity Analysis Container

This is a Singularity spec file that can be used to build a container and run on Dartmouth's [Discovery](http://techdoc.dartmouth.edu/discovery/) HPC cluster.

This container has been built a bit **differently** than the container on the the [main branch](https://github.com/cosanlab/cosanToolsSingularity/tree/master). Specifically its conda-based python environment is *editable* despite the container being read-only.

Location on Dartmouth's discovery cluster: `/dartfs/rc/lab/D/DBIC/cosanlab/Resources/cosanTools`

## Using the container on Discovery  

After ssh-ing to Discovery here's how you launch the container:  

1. Navigate to the folder mentioned above
2. Type `module load singularity`
3. Run this following script: `./run_container` or `bash run_container`
4. Create your own environment **you only need to do this once** the very first time you ever use the container: `conda create -n yourName --clone root`
4. Once you're inside the container you should **use your own environment**: `source activate ejolly`
5. Quit the container with ctrl+D

## Things to note
1. Make sure to ALWAYS run this container with the container_pkgs folder mounted
    - This means call `singularity run` or `singularity exec` with `-B path/to/container_pkgs:/container_pkgs`. Otherwise you won't be able to use Python/conda
    - This goes for developing the container on your Mac as well (see below): `singularity run -B /Volumes/CONDA/container_pkgs:/container_pkgs cosanTools.img`
2. Make sure to copy the `container_pkgs` folder along with the `.img` file if moving this container elsewhere

## Building a container from scratch with this repo  
(*assumes Singularity 2.3 and Mac OS*)  
1) You need to install a Vagrant virtual machine since it's not possible to install singularity on Mac OS. Follow the directions [here](http://singularity.lbl.gov/install-mac)
2) Add the following line to your `Vagrantfile` for the vagrant vm you're going to use to build the container: `config.vm.synced_folder "/Volumes/CONDA", "/vagrant_data"`
3) Create a new case-sensitive disk image that we're going to install conda into. This is required because Mac OS by default uses case-insensitive file-systems and the conda linux installer [doesn't like this](https://github.com/conda/conda/issues/6603).  
 Open Disk Utility. Go to: File > New Image > Blank Image
    1) Save as:
        - file name: conda_file_system
        - Name: CONDA
        - Size: 10,000MB
        - Format: OSX Extended (Case-Sensitive, Journaled)
    2) **If on OSX 10.11 (El Capitan)**: erase this and reformat as OSX Extended (Case-Sensitive, Journaled), due to this [bug](https://discussions.apple.com/thread/7395900)
- *Optionally use the `disk_maker.sh` program included in this repo instead of step 3*
4) Launch your vagrant vm: `vagrant up && vagrant ssh`
5) cd to `/vagrant` which is shared with your host OS
6) Create an empty singularity container: `sudo singularity create --size 8000 cosanTools.img`
7) Install the OS into the container `sudo singularity bootstrap cosanTools.img Singularity`
8) Mount the new CONDA volume you created and created a folder within it: `mkdir /Volumes/CONDA/container_pkgs && chmod 777 /Volumes/CONDA/container_pkgs`
9) Copy the setup script in this repo to that folder: `mv setup_container.sh /Volumes/CONDA/container_pkgs/`
10) Run the container with the setup script: `singularity exec --writable -B /Volumnes/CONDA/container_pkgs/:/container_pkgs cosanTools.img /container_pkgs/setup_container.sh`
11) You should be all set!
