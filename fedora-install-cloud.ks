# Kickstart file for composing the "Fedora" spin of Fedora (rawhide)
# Maintained by the Fedora Release Engineering team:
# https://fedoraproject.org/wiki/ReleaseEngineering
# mailto:rel-eng@lists.fedoraproject.org

# Use a part of 'iso' to define how large you want your isos.
# Only used when composing to more than one iso.
# Default is 695 (megs), CD size.
# Listed below is the size of a DVD if you wanted to split higher.
#part iso --size=4998

# Add the repos you wish to use to compose here.  At least one of them needs group data.

# Only uncomment repo commands in one of the two following sections.
# Because the install kickstart doesn't use the updates repo and does 
# use the source repo, we can't just include fedora-repo.ks

# In the master branch the rawhide repo commands should be uncommented.
#repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch
#repo --name=rawhide-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide-source&arch=$basearch

# In non-master branches the fedora repo commands should be uncommented
repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=fedora-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-$releasever&arch=$basearch

# Package manifest for the compose.  Uses repo group metadata to translate groups.
# (default groups for the configured repos are added by --default)
# @base got renamed to @standard, but @base is still included by default by pungi.
%packages --default

# pungi is an inclusive depsolver so that multiple packages are brought 
# in to satisify dependencies and we don't always want that. So we  use
# an exclusion list to cut out things we don't want

-kernel*debug*
-kernel-kdump*
-kernel-tools*
-syslog-ng*
-astronomy-bookmarks
-generic*
-GConf2-dbus*
-bluez-gnome
-community-mysql*
-jruby*

# core
kernel*
dracut-*

# Desktops

## common stuff
@base-x
@guest-desktop-agents
@guest-agents
@standard
@core
@dial-up
@fonts
@input-methods
@multimedia
@hardware-support
@printing
@admin-tools
@basic-desktop


@virtualization
@web-server
@mongodb
@perl-web
@php
@python-web
@rubyonrails
@mysql
@sql-server
@javaenterprise

# Things needed for installation
@anaconda-tools

# package cloud base image installs that probably should go in some comps group but what????
heat-cfntools

# Langpacks
autocorr-*
eclipse-nls-*
hunspell-*
hyphen-*
calligra-l10n-*
kde-l10n-*
libreoffice-langpack-*
man-pages-*
mythes-*
-gimp-help-*

# Removals
-PackageKit-zif
-zif
%end
