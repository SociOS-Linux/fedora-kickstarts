
# ./fedora-atomic-testing-base.ks - for building media from the testing
# refs (fedora/29/${basearch}/testing/atomic-host)

ostreesetup --nogpg --osname=fedora-atomic --remote=fedora-atomic --url=https://kojipkgs.fedoraproject.org/compose/atomic/repo/ --ref=fedora/29/${basearch}/testing/atomic-host

%post --erroronfail
# Find the architecture we are on
arch=$(uname -m)
# Set the origin to the "main stable ref", distinct from /testing/ which is where bodhi writes.
# We want consumers of this image to track the two week releases.
ostree admin set-origin --index 0 fedora-atomic https://dl.fedoraproject.org/atomic/repo/ "fedora/29/${arch}/atomic-host"

# Make sure the ref we're supposedly sitting on (according
# to the updated origin) exists.
ostree refs "fedora-atomic:fedora/29/${arch}/testing/atomic-host" --create "fedora-atomic:fedora/29/${arch}/atomic-host"

# Remove the old ref so that the commit eventually gets
# cleaned up.
ostree refs "fedora-atomic:fedora/29/${arch}/testing/atomic-host" --delete

# delete/add the remote with new options to enable gpg verification
# and to point them at the cdn url
ostree remote delete fedora-atomic
ostree remote add --set=gpg-verify=true --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-29-primary fedora-atomic 'https://dl.fedoraproject.org/atomic/repo/'

%end
