# Cours
## Network
```bash
# show * iptables
sudo iptables -vnl
```


bridge: carte réseaux qui agis comme un switch
```bash
##############################      ################################
#         ns: net HOS        #      #        ns: net CONT          #
# -> bridge:   172.16.0.0/16 #      #                              #
# -> vethpair: <-------------------------> nethpair-ip: 172.17.0.3 #
#                            #      #                              #
##############################      ################################
```


