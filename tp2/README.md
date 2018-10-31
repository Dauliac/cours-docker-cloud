# TP gitlab

## Requirements:
 - python == 3.7.0
 - vagrant == 2.1.5
 - ansible == 2.7.0
 - virtualbox == 5.2.18
 - nfs-utils == 2.3.3


docker login:

```bash
[vagrant@gitlab ~]$ docker login gitlab.domain.local:4567
Username: root
Password:
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
```

---

To have dns resolution your `/etc/resolv.conf` should look like this:
```bash
    cat /etc/resolv.conf
    nameserver 172.16.2.3
    nameserver 1.1.1.1
```

## Run

```bash
    vagrant up
```
You can connect with vagrant ssh command
```bash
    vagrant ssh gitlab
```
