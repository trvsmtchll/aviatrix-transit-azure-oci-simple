#!/bin/bash

sudo apt update -y

#install test packages
sudo apt-get -y install traceroute unzip build-essential git gcc iperf3 -y

git clone https://github.com/Microsoft/ntttcp-for-linux
cd ntttcp-for-linux/src
make; make install

cp ntttcp /usr/local/bin/
