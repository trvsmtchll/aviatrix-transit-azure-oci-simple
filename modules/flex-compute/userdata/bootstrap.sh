#!/bin/bash
echo "Welcome to Aviatrix OCI Testing Flex VM" >> /etc/motd
echo "" >> /etc/motd
echo "" >> /etc/motd
echo "Copy autonomous db wallets to \$TNS_ADMIN" >> /etc/motd
echo "" >> /etc/motd

yum install iperf3 wget -y && \
cd /home/opc && \

wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \
unzip instantclient-basic-linux.x64-21.1.0.0.0.zip && \
unzip instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \

echo "export LD_LIBRARY_PATH=/home/opc/instantclient_21_1" >> /home/opc/.bash_profile && \
echo "export PATH=\$PATH:/home/opc/instantclient_21_1" >> /home/opc/.bash_profile && \
echo "export TNS_ADMIN=/home/opc/instantclient_21_1/network/admin" >> /home/opc/.bash_profile && \

chown opc:opc /home/opc/.bash_profile && \
chown -R opc:opc /home/opc/instant* && \
rm /home/opc/*.zip

echo "${module.autonomous_db["db_spoke1"].private_endpoint_ip}  ${module.autonomous_db["db_spoke1"].private_endpoint}" >> /etc/hosts
