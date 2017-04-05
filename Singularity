#COSANLAB SINGULARITY BOOTSTRAP SPEC
#MAINTAINER ESHIN JOLLY <eshin.jolly.gr@dartmouth.edu>

Bootstrap: docker
From: ejolly/cosantoolsdocker

%runscript
	
    echo "Now inside Singularity container woah..."
    /bin/bash

%post
	
	echo "Environment setup...\n"
    
    # Make life a little easier with vim
    echo "Installing vim...\n"
    apt-get --assume-yes install vim

    # Make folders necessary for proper Discovery file system overlay
    echo "Configuring folders for Discovery...\n"
    mkdir -p /afs /inbox /ihome /opt
    chmod a+rX /afs /inbox /ihome /opt
    chmod a+rX -R /opt
    
    # Add ANTS and conda to PATH by editing Singularity environment file
    echo "Adding ANTS and conda to PATH...\n"
    sed -i '2iPATH=/opt/conda/bin:/opt/ants:$PATH' /environment
    sed -i '3iexport ANTSPATH=/opt/ants' /environment

    # Ensure conda is the supreme python leader (aka takes precedence in module search)
    sed -i '4iexport PYTHONPATH=/opt/conda/lib/python2.7/site-packages' /environment

    # Set the appropriate Matplotlib backend by specifying an rc file and setting the environment variable to search for it
    echo "Setting matplotlib backend...\n"
    mkdir /opt/matplotlib
    echo "backend: Agg" > /opt/matplotlib/matplotlibrc
    sed -i '5iexport MATPLOTLIBRC=/opt/matplotlib' /environment
   
    # Do the same for FSL
    echo "Adding FSL to PATH...\n"
    sed -i '5r /etc/fsl/fsl.sh' /environment

    # Source environment
    . /environment

    # Ensure most recent versions of pip, conda, and all packages
    echo "Updating pip...\n"
    pip install --upgrade pip
    echo "Updating conda packages...\n"
    conda update --all

    echo "All done!\n"
     