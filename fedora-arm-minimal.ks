%include fedora-arm-base.ks

part /boot --size=512 --fstype ext4
part swap --size=256 --fstype swap
part / --size=1200 --fstype ext4

%packages
-@standard
-initial-setup-gui
-generic-release*
-glibc-all-langpacks
glibc-langpack-en
iw
NetworkManager-wifi
%end

%post

# setup systemd to boot to the right runlevel
echo -n "Setting default runlevel to multiuser text mode"
rm -f /etc/systemd/system/default.target
ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
echo .

%end
