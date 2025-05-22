#!/bin/bash

set -e

echo "Open Source Silicon tools installation for IHP130 PDK will begin..."

if [[ $EUID -ne 0 ]]; then
   echo "Please run this script with: sudo ./scriptname.sh"
   exit 1
fi

echo "Creating base directories..."
mkdir -p ~/edatools/opentools
cd ~/edatools/opentools

echo "Updating and installing dependencies..."
apt update -y
apt upgrade -y

apt install -y build-essential autoconf automake patch patchutils libtool cmake git \
libgl1-mesa-dev libglu1-mesa-dev libxp-dev libxmu-dev tcl tk tcl-dev tk-dev libcairo2-dev \
graphviz libxaw7-dev libreadline-dev flex bison libopenmpi-dev openmpi-bin \
python3.11 python3.11-dev python3.11-venv python3.11-distutils python3-pip \
qtbase5-dev libqt5multimedia5 libqt5multimedia5-plugins libqt5xmlpatterns5-dev libqt5svg5-dev \
qttools5-dev qttools5-dev-tools ruby ruby-dev libgtk-3-dev libqt5charts5-dev \
vim-gtk3 xterm libjpeg-dev libgit2-dev

echo "Downloading source files..."
wget -O ngspice-44.2.tar.gz https://sourceforge.net/projects/ngspice/files/ng-spice-rework/44.2/ngspice-44.2.tar.gz/download
wget -O xschem-3.4.5.tar.gz https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.5.tar.gz
wget https://github.com/britovski/ihp130_skel/raw/refs/heads/main/extras/gaw3-20220315.tar.gz
wget -O openvaf.tar.gz https://datashare.tu-dresden.de/s/deELsiBGyitSS3o/download
wget https://www.klayout.org/downloads/source/klayout-0.29.0.tar.gz

echo "Installing OpenVAF..."
tar zxvpf openvaf.tar.gz
mv openvaf /usr/local/bin
rm -f openvaf.tar.gz

echo "Installing NGSpice 44.2..."
tar zxvpf ngspice-44.2.tar.gz
cd ngspice-44.2
./configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readline=yes \
            --enable-predictor --enable-osdi --enable-pss
make -j$(nproc)
make install
cd ..
rm -rf ngspice-44.2*

echo "Installing XSchem..."
tar zxvpf xschem-3.4.5.tar.gz
cd xschem-3.4.5
./configure
make -j$(nproc)
make install
cd ..
rm -rf xschem-3.4.5*

echo "Installing gaw..."
tar zxvpf gaw3-20220315.tar.gz
cd gaw3-20220315
./configure
make -j$(nproc)
make install
cd ..
rm -rf gaw3-20220315*

echo "Installing KLayout from source..."
tar zxvpf klayout-0.29.0.tar.gz
cd klayout-0.29.0
./build.sh -with-qtbinding -nolibgit2 -python python3.11 -prefix /usr/local
cd ..
rm -rf klayout-0.29.0*

echo "Installation complete!"
echo "You may now run the 'ihp130_workarea.sh' script in your environment."
