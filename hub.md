# Cours Docker Hub

## Registre
`HUB = registre public`
docker pull alpine => hub.docker.com/user/alpine


# Tp Docker Hub
## Part 1:
### Init:

installer `virtualbox` et `nfs-utils`

voir fonctions `disk` et `rm_disk`


storagectl                <uuid|vmname>
                            --name <name>
                            [--add ide|sata|scsi|floppy|sas|usb|pcie]
                            [--controller LSILogic|LSILogicSAS|BusLogic|
                                          IntelAHCI|PIIX3|PIIX4|ICH6|I82078|
                            [             USB|NVMe]
                            [--portcount <1-n>]
                            [--hostiocache on|off]
                            [--bootable on|off]
                            [--rename <name>]
                            [--remove]

vboxmanage storagectl --name tp2 --add sata --controller

VBoxManage storageattach my-vm-name \
                         --storagectl "SATA Controller" \
                         --device 0 \
                         --port 0 \
                         --type hdd \
                         --medium /path/to/my-new.vdi

### 1. Ajout d'un disque

### 2. Installer Docker

### 3. Installer gitlab-ce

### 4. Docker registry

### 5. Gitlab-runner

### 6. Build, build, build


