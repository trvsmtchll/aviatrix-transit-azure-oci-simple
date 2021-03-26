#!/bin/bash

sudo apt update -y

#install test packages
sudo apt-get -y install traceroute unzip build-essential git gcc iperf3 wget libaio1 libaio-dev -y && \

cd /home/azureuser && \

wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \
unzip instantclient-basic-linux.x64-21.1.0.0.0.zip && \
unzip instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \

echo "export LD_LIBRARY_PATH=/home/azureuser/instantclient_21_1" >> /home/azureuser/.bash_profile && \
echo "export PATH=\$PATH:/home/azureuser/instantclient_21_1" >> /home/azureuser/.bash_profile && \
echo "export TNS_ADMIN=/home/azureuser/instantclient_21_1/network/admin" >> /home/azureuser/.bash_profile && \

chown azureuser:azureuser /home/azureuser/.bash_profile && \
chown -R azureuser:azureuser /home/azureuser/instant* && \
rm /home/azureuser/*.zip