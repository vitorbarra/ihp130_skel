#!/bin/bash

echo "Open Source Silicon tools installation for IHP130 PDK will begin..."

#echo "You will need root permissions to perform tools installation..."


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Setting up directories..."

cd /
mkdir edatools 
cd edatools
#mkdir tools
#cd tools
mkdir opentools
cd opentools

echo "Solving dependencies..."
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y build-essential autoconf automake patch patchutils libtool python3 cmake git
sudo apt install -y libgl1-mesa-dev libglu1-mesa-dev libxp-dev libxmu-dev tcl tk tcl-dev tk-dev libcairo2-dev
sudo apt install -y graphviz libxaw7-dev libreadline-dev flex bison
sudo apt install -y libopenmpi-dev openmpi-bin
sudo apt install -y python3.11 python3.11-dev python3-pip
sudo apt install -y qtbase5-dev libqt5multimedia5 libqt5multimedia5-plugins libqt5xmlpatterns5-dev libqt5svg5-dev qttools5-dev qttools5-dev-tools
sudo apt install -y ruby ruby-dev libgtk-3-dev

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 python3.11-dev python3.11-venv python3.11-distutils -y

sudo apt install -y qtbase5-dev qttools5-dev qttools5-dev-tools \
                    qtmultimedia5-dev libqt5multimediawidgets5

#python3-devel

#git2
# Atualiza repositórios e pacotes
sudo apt update -y
sudo apt upgrade -y

# Repositório EPEL (não necessário no Ubuntu – ignorado)

# Equivalente do qt5-qtcharts
sudo apt install -y libqt5charts5-dev

# Ferramentas extras
sudo apt install -y vim-gtk3 xterm libjpeg-dev libgit2-dev


echo "Downloading tools..."

wget -O ngspice-44.2.tar.gz https://sourceforge.net/projects/ngspice/files/ng-spice-rework/44.2/ngspice-44.2.tar.gz/download #https://sourceforge.net/projects/ngspice/files/ng-spice-rework/44.2/ngspice-44.2.tar.gz/download
#wget -O adms-2.3.6.tar.gz https://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.6.tar.gz/download

#wget http://opencircuitdesign.com/magic/archive/magic-8.3.494.tgz
#http://opencircuitdesign.com/magic/archive/magic-8.3.78.tgz

#wget http://opencircuitdesign.com/netgen/archive/netgen-1.5.281.tgz
#http://opencircuitdesign.com/netgen/archive/netgen-1.5.155.tgz

#wget https://www.klayout.org/downloads/CentOS_7/klayout-0.29.0-0.x86_64.rpm

wget https://www.klayout.org/downloads/source/klayout-0.29.0.tar.gz

wget -O xschem-3.4.5.tar.gz https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.5.tar.gz

#wget http://download.tuxfamily.org/gaw/download/gaw3-20220315.tar.gz
wget https://github.com/britovski/ihp130_skel/raw/refs/heads/main/extras/gaw3-20220315.tar.gz

wget https://datashare.tu-dresden.de/s/deELsiBGyitSS3o/download/openvaf_devel-x86_64-unknown-linux-gnu.tar.gz

#wget https://github.com/ra3xdh/qucs_s/releases/download/24.3.2/qucs-s-24.3.2.tar.gz

#wget -O openems-v0.0.36.tar.gz https://github.com/thliebig/openEMS-Project/archive/refs/tags/v0.0.36.tar.gz


#!/bin/bash

set -e

echo "Downloading tools..."

wget -O ngspice-44.2.tar.gz https://sourceforge.net/projects/ngspice/files/ng-spice-rework/44.2/ngspice-44.2.tar.gz/download
wget https://www.klayout.org/downloads/source/klayout-0.29.0.tar.gz
wget -O xschem-3.4.5.tar.gz https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.5.tar.gz
wget https://github.com/britovski/ihp130_skel/raw/refs/heads/main/extras/gaw3-20220315.tar.gz
wget https://datashare.tu-dresden.de/s/deELsiBGyitSS3o/download/openvaf_devel-x86_64-unknown-linux-gnu.tar.gz -O openvaf.tar.gz

echo "Installing OpenVAF..."
tar zxvpf openvaf.tar.gz
sudo mv openvaf /usr/local/bin
rm -f openvaf.tar.gz

echo "Installing NGSpice 44.2 with OSDI/OpenVAF and XSPICE support..."
tar zxvpf ngspice-44.2.tar.gz
cd ngspice-44.2

./configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readline=yes --enable-predictor --enable-osdi --enable-pss
make -j$(nproc)
sudo make install

if [ $? -ne 0 ]; then
    echo "Failed to install NGSpice."
    exit 1
fi

cd ..
rm -f ngspice-44.2.tar.gz

echo "Done!"


echo "Installing Magic Layout..."
tar zxvpf magic-8.3.78.tgz
cd magic-8.3.78
./configure
make
make install
cd ..

echo "Installing Netgen..."
tar zxvpf netgen-1.5.155.tgz
cd netgen-1.5.155
./configure
make
make install
sudo apt install -y tcl-dev tk-dev libtk8.6 libtcl8.6

echo "Installing XSchem..."
tar zxvpf xschem-3.4.5.tar.gz
cd xschem-3.4.5
./configure
make
make install
if [ $? -ne 0 ]; then
    echo "Failed to install XSchem."
    exit 1
fi
cd ..
rm -f xschem-3.4.5.tar.gz


echo "Installing gaw..."
tar zxvpf gaw3-20220315.tar.gz
cd gaw3-20220315
./configure
make
make install
if [ $? -ne 0 ]; then
    echo "Failed to install GAW."
    exit 1
fi
cd ..
rm -f gaw3-20220315.tar.gz

echo "Installing KLayout..."
sudo localinstall klayout-0.29.0-0.x86_64.rpm -y
tar zxvpf klayout-0.29.0.tar.gz
cd klayout-0.29.0
./build.sh -with-qtbinding -nolibgit2 -python python3.11 -prefix /usr/local/bin
if [ $? -ne 0 ]; then
    echo "Failed to install KLayout."
    exit 1
fi
rm -f klayout-0.29.0-0.x86_64.rpm

#echo "Installing qucs-s"
#sudo apt install qtbase5-dev qttools5-dev qttools5-dev-tools libqt5svg5-dev
#sudo apt install qt6-base-dev qt6-tools-dev qt6-tools-dev-tools
#sudo apt install qt6-svg-dev
#sudo apt install -y qt6-base-dev qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools
#sudo qt6-svg-dev qt6-charts-dev qt6-multimedia-dev qt6-multimediawidgets-dev qt6-opengl-dev
#sudo qt6-networkauth-dev qt6-shadertools-dev qt6-3d-dev qt6-5compat-dev
#wget http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz
#git clone https://github.com/ra3xdh/qucs_s.git
#tar zxvpf gperf-3.1.tar.gz
#cd gperf-3.1
#./configure
#sudo make
#sudo make install
#cd ..
#sudo rm -rf gperf*
#cd qucs_s
#git submodule init
#git submodule update
#mkdir builddir
#cd builddir
#cmake -DQt5_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt5 ..
#sudo make -j $(nproc)
#sudo make install
#cd ..

echo "Minimal EDA open source tools installation done!"
echo "Back to user and run the 'ihp130_workarea.sh' script"
