#!/usr/bin/env bash

echo ${public_ssh_key} >> /home/${bastion_user_name}/.ssh/authorized_keys
echo ${qubole_public_key} >> /home/${bastion_user_name}/.ssh/authorized_keys

bash -c 'echo "GatewayPorts yes" >> /etc/ssh/sshd_config'
sudo service ssh restart