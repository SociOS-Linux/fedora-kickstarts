# This is a basic Fedora cloud spin designed to work in OpenStack and other
# private cloud environments. It's configured with cloud-init so it will
# take advantage of ec2-compatible metadata services for provisioning ssh
# keys. Cloud-init creates a user account named "fedora" with passwordless
# sudo access. The root password is empty and locked by default.
#
# This kickstart file is designed to be used with ImageFactory (in Koji).
#
# To do a local build, you'll need to install ImageFactory.  See
# http://worknotes.readthedocs.org/en/latest/cloudimages.html for some notes.
#
# For a TDL file, I store one here:
# https://pagure.io/fedora-atomic/raw/master/f/fedora-atomic-rawhide.tdl
# (Koji generates one internally...what we really want is Koji to publish it statically)
#
# Once you have imagefactory and imagefactory-plugins installed, run:
#
#   curl -O https://pagure.io/fedora-atomic/raw/master/f/fedora-atomic-rawhide.tdl
#   tempfile=$(mktemp --suffix=.ks)
#   ksflatten -v F22 -c fedora-cloud-base.ks > ${tempfile}
#   imagefactory --debug base_image --file-parameter install_script ${tempfile} fedora-atomic-rawhide.tdl
#

text # don't use cmdline -- https://github.com/rhinstaller/anaconda/issues/931
lang en_US.UTF-8
keyboard us
timezone --utc Etc/UTC

selinux --enforcing
rootpw --lock --iscrypted locked

firewall --disabled

# We pass net.ifnames=0 because we always want to use eth0 here on all the cloud images.
bootloader --timeout=1 --append="no_timer_check net.ifnames=0 console=tty1 console=ttyS0,115200n8"

services --enabled=sshd,cloud-init,cloud-init-local,cloud-config,cloud-final

zerombr
clearpart --all
autopart --noboot --nohome --noswap --nolvm

%include fedora-repo.ks

reboot

# Package list.
%packages --instLangs=en

kernel-core
@^cloud-server-environment
# Need to pull in the udev subpackage
systemd-udev

# after move away from grub2 - let's add 'which' back
which

# rescue mode generally isn't useful in the cloud context
-dracut-config-rescue

# Some things from @core we can do without in a minimal install
-biosdevname
# Need to also add back plymouth in order to mask failure of
# systemd-vconsole-setup.service. BZ#1272684. Comment out for now
#-plymouth
-iprutils
# Now that BZ#1199868 is fixed kbd really gets removed but it breaks
# systemd-vconsole-setup.service on boot. Comment out for now
#-kbd
-uboot-tools
-kernel
# No need for plymouth. Also means anaconda won't put rhgb/quiet
# on kernel command line
-plymouth
# noswap on Cloud for now
-zram-generator-defaults

%end



%post --erroronfail


# this is installed by default but we don't need it in virt
# Commenting out the following for #1234504
# rpm works just fine for removing this, no idea why dnf can't cope
echo "Removing linux-firmware package."
rpm -e linux-firmware

# Remove firewalld; was supposed to be optional in F18+, but is pulled in
# in install/image building.
echo "Removing firewalld."
# FIXME! clean_requirements_on_remove is the default with DNF, but may
# not work when package was installed by Anaconda instead of command line.
# Also -- check if this is still even needed with new anaconda -- disabled
# firewall should _not_ pull in this package.
# dnf -C -y remove "firewalld*" --setopt="clean_requirements_on_remove=1"
dnf -C -y erase "firewalld*"

echo "Removing random-seed so it's not the same in every image."
rm -f /var/lib/systemd/random-seed

echo "Import RPM GPG key"
releasever=$(rpm --eval '%{fedora}')
basearch=$(uname -i)
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch

echo "Zeroing out empty space."
# This forces the filesystem to reclaim space from deleted files
dd bs=1M if=/dev/zero of=/var/tmp/zeros || :
rm -f /var/tmp/zeros
echo "(Don't worry -- that out-of-space error was expected.)"

# When we build the image a networking config file gets left behind.
# Let's clean it up.
echo "Cleanup leftover networking configuration"
rm -f /etc/NetworkManager/system-connections/*.nmconnection

# Remove machine-id on pre generated images
rm -f /etc/machine-id
touch /etc/machine-id


%end

