#!/bin/bash

# Run via
# singularity exec --writable -B /Volumes/CONDA/container_pkgs/:/container_pkgs cosanTools.img /container_pkgs/setup_container.sh

# 1) Download Anaconda and install it in an volume external to the container
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
/bin/bash ~/anaconda.sh -b -p /container_pkgs/conda && \
rm ~/anaconda.sh

# Conda > 5.0.0 uses 3 new compiler packages vs old single 'gcc'
conda install -y gcc_linux-64 gxx_linux-64 gfortran_linux-64
conda update pandas

# Install additional packages using pip
pip install hypertools nipy mne nipype nltools datalad[full]
