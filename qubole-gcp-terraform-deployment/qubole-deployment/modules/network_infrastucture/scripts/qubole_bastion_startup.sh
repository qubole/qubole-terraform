#!/usr/bin/env bash

sudo useradd bastion-user -p ''
mkdir -p /home/bastion-user/.ssh
chown -R bastion-user:bastion-user /home/bastion-user/.ssh

qubole_public_key=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/qubole_public_key -H "Metadata-Flavor: Google")
public_ssh_key=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/account_ssh_key -H "Metadata-Flavor: Google")

echo ${public_ssh_key} >> /home/bastion-user/.ssh/authorized_keys
echo ${qubole_public_key} >> /home/bastion-user/.ssh/authorized_keys
bash -c 'echo "GatewayPorts yes" >> /etc/ssh/sshd_config'
sudo service ssh restart