#!/bin/bash

rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*

dpkg --clear-avail


apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils
	## Basic deps
apt-get install -y --no-install-recommends \
	gdb \
	libxml2-dev \
	python3-pip \
	libz-dev \
	liblzma-dev \
	libbz2-dev \
	libpng-dev \
	libgit2-dev
	## sys deps from bioc_full
apt-get install -y --no-install-recommends \
	pkg-config \
	fortran77-compiler \
	byacc \
	automake \
	curl
	## This section installs libraries
apt-get install -y --no-install-recommends \
	libpcre2-dev \
	libnetcdf-dev \
	libhdf5-serial-dev \
	libfftw3-dev \
	libopenbabel-dev \
	libopenmpi-dev \
	libxt-dev \
	libudunits2-dev \
	libgeos-dev \
	libproj-dev \
	libcairo2-dev \
	libtiff5-dev \
	libreadline-dev \
	libgsl0-dev \
	libgslcblas0 \
	libgtk2.0-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libgmp3-dev \
	libhdf5-dev \
	libncurses-dev \
	libbz2-dev \
	libxpm-dev \
	liblapack-dev \
	libv8-dev \
	libgtkmm-2.4-dev \
	libmpfr-dev \
	libmodule-build-perl \
	libapparmor-dev \
	libprotoc-dev \
	librdf0-dev \
	libmagick++-dev \
	libsasl2-dev \
	libpoppler-cpp-dev \
	libprotobuf-dev \
	libpq-dev \
	libperl-dev
	## software - perl extentions and modules
apt-get install -y --no-install-recommends \
	libarchive-extract-perl \
	libfile-copy-recursive-perl \
	libcgi-pm-perl \
	libdbi-perl \
	libdbd-mysql-perl \
	libxml-simple-perl \
	libmysqlclient-dev \
	default-libmysqlclient-dev \
	libgdal-dev 
	## new libs
apt-get install -y --no-install-recommends \
    libglpk-dev \
    libeigen3-dev 
	## Databases and other software
apt-get install -y --no-install-recommends \
	sqlite \
	openmpi-bin \
	mpi-default-bin \
	openmpi-common \
	openmpi-doc \
	tcl8.6-dev \
	tk-dev \
	default-jdk \
	imagemagick \
	tabix \
	ggobi \
	graphviz \
	protobuf-compiler \
	jags
	## Additional resources
apt-get install -y --no-install-recommends \
	xfonts-100dpi \
	xfonts-75dpi \
	biber \
        libsbml5-dev \
        libzmq3-dev
        ## python3 dev
apt-get install -y --no-install-recommends python3-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

pip3 install sklearn \
        pandas \
        pyyaml

apt-get update \
	&& apt-get -y --no-install-recommends install \
	libmariadb-dev-compat \
	libjpeg-dev \
	libjpeg-turbo8-dev \
	libjpeg8-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site

R -f /tmp/scripts/install.R

curl -O http://bioconductor.org/checkResults/devel/bioc-LATEST/Renviron.bioc \
	&& cat Renviron.bioc | grep -o '^[^#]*' | sed 's/export //g' >>/etc/environment \
	&& cat Renviron.bioc >> /usr/local/lib/R/etc/Renviron.site \
	&& echo BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
        && echo BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_DOCKER_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
        && echo 'LIBSBML_CFLAGS="-I/usr/include"' >> /usr/local/lib/R/etc/Renviron.site \
        && echo 'LIBSBML_LIBS="-lsbml"' >> /usr/local/lib/R/etc/Renviron.site \
	&& rm -rf Renviron.bioc

