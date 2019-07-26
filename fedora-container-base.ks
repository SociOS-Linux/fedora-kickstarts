# See fedora-container-common.ks for details on how to hack on container image kickstarts
# This base is a standard Fedora image with python3 and dnf

%include fedora-container-common.ks

%packages --excludedocs --instLangs=en --nocore --excludeWeakdeps
rootfiles
# https://communityblog.fedoraproject.org/modularity-dead-long-live-modularity/
fedora-repos-modular
tar # https://bugzilla.redhat.com/show_bug.cgi?id=1409920
vim-minimal
dnf
dnf-yum  # https://fedorahosted.org/fesco/ticket/1312#comment:29
sssd-client
sudo
-glibc-langpack-en
-cracklib-dicts
-dejavu-sans-fonts
%end

%post --erroronfail --log=/root/anaconda-post.log
# remove some extraneous files
rm -rf /var/cache/dnf/*
rm -rf /tmp/*

# https://pagure.io/atomic-wg/issue/308
printf "tsflags=nodocs\n" >>/etc/dnf/dnf.conf

# https://bugzilla.redhat.com/show_bug.cgi?id=1576993
systemctl disable dnf-makecache.timer

#Mask mount units and getty service so that we don't get login prompt
systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service getty.target console-getty.service

# https://bugzilla.redhat.com/show_bug.cgi?id=1343138
# Fix /run/lock breakage since it's not tmpfs in docker
# This unmounts /run (tmpfs) and then recreates the files
# in the /run directory on the root filesystem of the container
#
# We ignore the return code of the systemd-tmpfiles command because
# at this point we have already removed the /etc/machine-id and all
# tmpfiles lines with %m in them will fail and cause a bad return
# code. Example failure:
#   [/usr/lib/tmpfiles.d/systemd.conf:26] Failed to replace specifiers: /run/log/journal/%m
#
umount /run
systemd-tmpfiles --prefix=/run/ --prefix=/var/run/ --create --boot || true
rm /run/nologin # https://pagure.io/atomic-wg/issue/316

# Remove some dnf info
rm -rfv /var/lib/dnf

# if you want to change the timezone, bind-mount it from the host or reinstall tzdata
# Work around waiting for a tzdata-minimal package see https://bugzilla.redhat.com/show_bug.cgi?id=1733452
rm -fv /etc/localtime
mv /usr/share/zoneinfo/UTC /etc/localtime
rm -rfv  /usr/share/zoneinfo

# Final pruning
rm -rfv /var/cache/* /var/log/* /tmp/*

%end

%post --nochroot --erroronfail --log=/mnt/sysimage/root/anaconda-post-nochroot.log
set -eux

# See: https://bugzilla.redhat.com/show_bug.cgi?id=1051816
# NOTE: run this in nochroot because "find" does not exist in chroot
KEEPLANG=en_US
for dir in locale i18n; do
    find /mnt/sysimage/usr/share/${dir} -mindepth  1 -maxdepth 1 -type d -not \( -name "${KEEPLANG}" -o -name POSIX \) -exec rm -rfv {} +
done

%end
