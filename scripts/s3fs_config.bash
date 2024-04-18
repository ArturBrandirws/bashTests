#!/bin/bash

install_s3fs() {
  echo "Installing s3fs 1.94"

  sudo apt update
  ## install useful libs to complete s3fs 1.94 installation
  sudo apt -y install gcc make pkg-config fuse libfuse-dev libcurl4-openssl-dev libxml2-dev libssl-dev
  
  ## get the 1.94 version of s3fs from github
  wget https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.94.tar.gz

  ## unzip the file
  tar -xzvf v1.94.tar.gz

  cd s3fs-fuse-1.94

  ## prepare the installation
  sudo apt-get -y install autoconf automake libtool
  ## prepare the installation
  ./autogen.sh
  ## prepare the installation
  sudo apt-get -y install g++
  ## prepare the installation
  ./configure 
  ## prepare the installation
  make

  ## install s3fs 1.94 
  sudo make install
}

main () {

  ## Intalls s3fs
  install_s3fs

}

main