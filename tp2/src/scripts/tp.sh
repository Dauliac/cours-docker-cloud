#!/bin/bash
# Author      : github.com/Dauliac
# Version     : 0.0.1

VGN=data-docker
VGD=/dev/sdb
VN=data01


disk(){
    # parted ${VGD} mklabel gpt
    # parted -a opt ${VGD} mkpart primary ext4 0% 100%
    pvcreate ${VGD}
    vgcreate ${VGN} ${VGD}
    lvcreate -L 15000 -n ${VN} ${VGN}
    mkdir -p /data/docker
    mount /dev/${VGN}/${VN} /data
}

dockerd(){
    mkdir -p /data/docker
    echo '{"graph": "/data/docker"}' > /etc/docker/daemon.json


}

gitlab(){
    yum install -y curl policycoreutils-python openssh-server openssh-clients
    systemctl enable sshd
    systemctl start sshd

    firewall-cmd --permanent --add-service=http
    systemctl reload firewalld

    yum install postfix
    systemctl enable postfix
    systemctl start postfix
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
    EXTERNAL_URL="http://gitlab.example.com" yum install -y gitlab-ce
}

ssl(){
    openssl req -new -newkey rsa:2048 \
        -days 365 \
        -nodes -x509 \
        -keyout $(echo HOSTNAME).key \
        -out $(echo HOSTNAME).crt
    mv $(HOSTANAME).* /etc/gitlab/ssl/
    sed -i "s/external_url */external_url 'https://'$(echo HOSTNAME)/" /etc/gitlab/gitlab.rb
    gitlab-ctl reconfigure
}

install(){
    # disk
    dockerd
}


###################################
# REVERT
###################################

rm_disk(){
    lvremove -y ${VN}
    vgremove -y ${VGN}
    pvremove -y ${VGD}1
    wipefs -af /dev/sdb
    umount /data
    rm -Rf /data
}

rm_docker(){
    echo 2
}

revert() {
    rm_disk
}


while [ ! $# -eq 0 ]
do
    case "$1" in
        --install | -r)
            install
            ;;
        --revert | -r)
            revert
            ;;
    esac
    shift
done
