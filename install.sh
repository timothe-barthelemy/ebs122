#grep apps /etc/hosts || sudo echo 127.0.0.1 apps >> /etc/hosts
podman container rm -f apps.example.com
podman network rm ebs12212
podman volume rm ebs12212
rm -f root.gz u01.gz Oracle-E-Business-Suite-12.2.12_VISION_INSTALL-disk001.vmdk Oracle-E-Business-Suite-12.2.12_VISION_INSTALL.ovf
tar -xvf Oracle-E-Business-Suite-12.2.12_VISION_INSTALL.ova
export LIBGUESTFS_BACKEND=direct 
guestfish --ro -a Oracle-E-Business-Suite-12.2.12_VISION_INSTALL-disk001.vmdk <<EOF
RUN
mount /dev/ol/root /
mount /dev/sda1 /boot
tar-out / - | gzip -1 >> root.gz
mount /dev/ol/home /u01
tar-out /u01 - | gzip -1 >> u01.gz
exit
EOF
rm -f Oracle-E-Business-Suite-12.2.12_VISION_INSTALL-disk001.vmdk Oracle-E-Business-Suite-12.2.12_VISION_INSTALL.ovf
podman build --no-cache --layers=false -t ebs12212 .
podman network create ebs12212
podman volume create ebs12212
podman volume import ebs12212 u01.gz
rm -f root.gz u01.gz 
podman container run -d -p 8000:8000 -p 1521:1521 -p 7001:7001 -p 7002:7002 -v ebs12212:/u01 --network ebs12212 --hostname apps.example.com --name apps ebs12212 
