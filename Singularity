#COSANLAB SINGULARITY BOOTSTRAP SPEC
#MAINTAINER ESHIN JOLLY <eshin.jolly.gr@dartmouth.edu>

Bootstrap: docker
From: ubuntu:xenial-20161213

%labels
	Maintainer eshin.jolly.gr@dartmouth.edu

%post
	# Install required system packages
	apt-get update --fix-missing && apt-get install -y eatmydata
	eatmydata apt-get install -y wget bzip2 ca-certificates \
	    libglib2.0-0 libxext6 libsm6 libxrender1 libfreetype6-dev \
	    git \
	    mercurial \
	    subversion \
	    curl grep sed \
	    dpkg \
	    graphviz \
	    vim nano \
	    libgl1-mesa-glx \
	    ffmpeg \
	    fonts-liberation \
	    build-essential \
	    gcc \
	    pkg-config \
	    ca-certificates \
	    xvfb \
	    autoconf \
	    libtool

	# Add Neurodebian package repositories (i.e. for FSL)
	curl -sSL http://neuro.debian.net/lists/trusty.us-nh.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
	    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
	    apt-get update

	# Datalad dependency
	eatmydata apt-get install git-annex-standalone

	#######################
	### Setup Anaconda ####
	#######################

	# Because we want a writable conda environment we're going to install it using the setup_container.sh script which should be run after the container is built

	# Here we're just going to create the required folders within the container and set the PATH properly
	mkdir -p /container_pkgs
	chmod a+rwX -R /container_pkgs

    # Create a condarc file to handle where environments are installed by default
	echo "envs_dirs:" > ~/.condarc
    echo "  - /container_pkgs/conda/envs" >> ~/.condarc


	# Set the appropriate Matplotlib backend by specifying an rc file and setting the environment variable to search for it
	mkdir /opt/matplotlib
	echo "backend: Agg" > /opt/matplotlib/matplotlibrc


	###################
	### Setup ANTS ####
	###################

	# Download and install (NeuroDocker build)
	ANTSPATH="/usr/lib/ants"
	mkdir -p $ANTSPATH && \
	    curl -sSL "https://dl.dropbox.com/s/2f4sui1z6lcgyek/ANTs-Linux-centos5_x86_64-v2.2.0-0740f91.tar.gz" \
	    | tar -xzC $ANTSPATH --strip-components 1

	# Setup path
	export PATH=$ANTSPATH:$PATH

	#################
	## Setup FSL ####
	#################

	# Install
	eatmydata apt-get install -y fsl-core && \
	    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

	#############################################################
	## Setup for Discovery cluster file system overlay issue ####
	#############################################################

	# Make folders necessary for proper Discovery file system overlay
    mkdir -p /afs /inbox /ihome /opt /idata /environment /dartfs /dartfs-hpc /data /srv /scratch
    chmod a+rX /afs /inbox /ihome /opt /idata /environment /dartfs /dartfs-hpc /data /srv /scratch
    chmod a+rwX -R /opt

%environment
	export PATH=/usr/lib/ants:$PATH
	export ANTSPATH=/usr/lib/ants
	export MATPLOTLIBRC=/opt/matplotlib
	export FSLDIR=/usr/share/fsl/5.0
	export FSLOUTPUTTYPE=NIFTI_GZ
	export PATH=/usr/lib/fsl/5.0:$PATH
	export FSLMULTIFILEQUIT=TRUE
	export POSSUMDIR=/usr/share/fsl/5.0
	export LD_LIBRARY_PATH=/usr/lib/fsl/5.0:$LD_LIBRARY_PATH
	export FSLTCLSH=/usr/bin/tclsh
	export FSLWISH=/usr/bin/wish
	export FSLOUTPUTTYPE=NIFTI_GZ
	export LANG=C.UTF-8
	export LC_ALL=C.UTF-8
	export PATH=/container_pkgs/conda:$PATH

%runscript
if [ ! -z "$1" ] && [ $1 = 'root' ]; then
	echo "Entering container as conda root"
	/bin/bash
else
	echo "Entering container..."
	echo "Checking if you exist..."
	if conda env list | grep -q `whoami`; then
        	source activate `whoami`
		clear
		echo "Started your environment...do cool science!"
		/bin/bash
	else
        	echo "You weren't found."
        	read -p "Create conda environment for you? (y/n) "
        	echo
        	if [[ $REPLY =~ ^[Yy]$ ]]; then
                	echo "Creating new environment (this may take a few min)"
			conda create -y -n `whoami` --clone root
			source activate `whoami`
                	/bin/bash
        	else
                	echo "Goodbye (please create an environment to use this container)"
			exit 1
         	fi
	fi
fi
