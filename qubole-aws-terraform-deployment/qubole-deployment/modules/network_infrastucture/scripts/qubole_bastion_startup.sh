#!/usr/bin/env bash

mkdir -p /home/ec2-user/.ssh

echo ${public_ssh_key} >> /home/ec2-user/.ssh/authorized_keys
echo ${qubole_public_key} >> /home/ec2-user/.ssh/authorized_keys
