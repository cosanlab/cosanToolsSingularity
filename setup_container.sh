#!/bin/bash

# This script uses the premade container (with Anaconda installed) to create a conda virtual environment that exists *outside* the container in a folder shared with the host OS and sets that to the default conda environment by editing the PATH

# This makes it easy for the user to install and modify conda/pip packages in a read-only container, by utilizing this shared folder /container_pkgs

# First make sure the host OS has a folder called container_pkgs at the same location as the container image
# mkdir container_pkgs

# Second place this script within that folder

# Then run this script with the container using:
# singularity exec --writable -B ./container_pkgs/:/container_pkgs cosanTools.img /container_pkgs/setup_container.sh

conda create -p /container_pkgs --clone root
source activate /container_pkgs

# Install additional packages using pip
pip install hypertools nipy mne nipype nltools
pip install git+https://github.com/cosanlab/cosanlab_preproc
