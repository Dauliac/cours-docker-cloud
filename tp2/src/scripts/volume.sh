#!/bin/bash

# TODO set variable SIZE VOLUME

# Physical volume Creation
pvcreate /dev/sdb

# Volume Group creation
vgcreate docker /dev/sdb

# Logical Volume Thinpool creation
lvcreate --wipesignatures y -n thinpool docker -l 50%VG
lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG

# Convert lv
lvconvert -y \
    --zero n \
    -c 512K \
    --thinpool docker/thinpool \
    --poolmetadata docker/thinpoolmeta

cp /vagrant/config/docker-thinpool.profile /etc/lvm/profile/docker-thinpool.profile

lvchange --metadataprofile docker-thinpool docker/thinpool

# Enable monitoring
lvs -o+seg_monitor

mkdir /etc/docker
cp /vagrant/config/daemon.json /etc/docker/daemon.json

# TODO Automount partition with fstab
