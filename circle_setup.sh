#!/bin/bash

set -x
set -e

# Folder for downloads
mkdir -p ${HOME}/downloads

# Download md5 checksums
if [[ ! -s ${HOME}/downloads/fsl-5.0.9-centos6_64.tar.gz.md5 ]]; then
    wget -P ${HOME}/downloads/ "http://fsl.fmrib.ox.ac.uk/fsldownloads/md5sums/fsl-5.0.9-centos6_64.tar.gz.md5"
fi

if [[ ! -s ${HOME}/downloads/linux_openmp_64.tgz.md5 ]]; then
    wget -P ${HOME}/downloads/ -O linux_openmp_64.tgz.md5 "https://drive.google.com/open?id=0BxI12kyv2olZV0tpZ3VJYjJ6NWM"
fi

cd ${HOME}/downloads
fslchk=$(md5sum -c fsl-5.0.9-centos6_64.tar.gz.md5 | awk '{print $2}')
afnichk=$(md5sum -c linux_openmp_64.tgz.md5 | awk '{print $2}')
cd

# Get fsl if md5 is not ok
if [ $fslchk != "OK" ]; then 
    wget -P ${HOME}/downloads/ "http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos6_64.tar.gz"
fi

if [[ ! -d ${HOME}/fsl ]]; then 
    tar zxvf ${HOME}/downloads/fsl-5.0.9-centos6_64.tar.gz -C ${HOME}
fi
source ${HOME}/fsl/etc/fslconf/fsl.sh

# Get afni if md5 is not ok
if [ $afnichk != "OK" ]; then
    wget -P ${HOME}/downloads/ "http://afni.nimh.nih.gov/pub/dist/tgz/linux_openmp_64.tgz"
fi

if [[ ! -d ${HOME}/afni ]]; then
    tar zxvf ${HOME}/downloads/linux_openmp_64.tgz
    mv linux_openmp_64 ${HOME}/afni
fi

# Get test data
if [[ ! -d ${HOME}/examples/ds003_downsampled ]]; then
    wget -P ${HOME}/downloads/ "https://googledrive.com/host/0B2JWN60ZLkgkMEw4bW5VUUpSdFU/ds003_downsampled.tar"
    mkdir -p ${HOME}/examples
    tar xvf ${HOME}/downloads/ds003_downsampled.tar -C ${HOME}/examples
fi