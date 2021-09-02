%packages

# Installing the default/mandatory packages from engineering & scientific
@engineering-and-scientific

# scilab
## scilab
## scilab-devel
## scilab-doc

# Remove sagemath explicitly?
-sagemath

#Devel tools

#Install the mandatory packages from dev-tools and dev-libs
# C/C++ compiler, gdb, autotools, bison, flex, make, strace..
@development-tools
@development-libs
@c-development
@rpm-development-tools
#others, not included
# C++ libraries
blitz-devel
armadillo-devel

# Misc. related utils
ddd
valgrind


#python 3 and tools/libraries not included from the groups
python3
python3-tools
python3-matplotlib
python3-scipy
python3-numpy
python3-ipython
python3-ipython-console
python3-ipython-notebook
python3-sympy
python3-networkx
python3-pandas

# matplotlib backends
python3-matplotlib-qt5
python3-matplotlib-tk

# Include Java development tools
@java-development
apache-commons-math

#fortran compiler
gcc-gfortran

# GUI for R
rkward

# julia
julia
julia-doc
julia-devel

python3-spyder
python3-spyder-kernels


#writing & publishing
emacs
emacs-color-theme
vim
scribus
#scite
lyx
kile

#Presentation, Bibliography & Document arrangement 
#tools
BibTool
pdfshuffler

# Parallel/Distributed computing libraries/tools
openmpi
openmpi-devel
valgrind-openmpi
libgomp
python3-mpi4py-openmpi
python3-mpi4py-mpich

#Version control- a GUI for each as well

# Installing rapidsvn will also install subversion package
rapidsvn 
git
git-gui
# Mercurial
mercurial
mercurial-hgk

#Backup Utilities
backintime-kde

#needs to install this specifically because of some conflict between openmpi
#and emacs (http://lists.fedoraproject.org/pipermail/devel/2011-July/153812.html)
libotf

#root
root
root-gui-fitpanel

#Multiple jobs/clustering system
# torque
# torque-server
# torque-scheduler
# torque-gui
# torque-libs
# torque-mom
# python-pbs

#Drawing, Picture viewing tools, Visualization tools
dia
inkscape
xzgv
gimp
## ggobi
## ggobi-devel
#g3data
#Mayavi

#Misc. Utils
screen
tmux
rlwrap
hexchat
fig2ps
bibtex2html
hevea

#Include Mozilla Firefox
firefox

%end
