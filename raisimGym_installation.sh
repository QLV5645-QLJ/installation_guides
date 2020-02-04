#!/bin/bash
cd ~
mkdir raisim_ws
mkdir raisim_build
WORKSPACE=~/raisim_ws
LOCAL_BUILD=~/raisim_build
export LOCAL_BUILD=~/raisim_build
export WORKSPACE=~/raisim_ws

#installation for raisimLib
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update
sudo apt install g++-8 gcc-8 -y
sudo apt-get install libeigen3-dev -y
cd ~/raisim_ws
git clone https://github.com/leggedrobotics/raisimLib.git
cd raisimLib
mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD && make install

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LOCAL_BUILD/lib
export CXX=/usr/bin/g++-8 && export CC=/usr/bin/gcc-8
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/raisim_build/lib" >>~/.bashrc

#installation for orge
sudo apt-get install libgles2-mesa-dev libxt-dev libxaw7-dev -y
sudo apt-get install libsdl2-dev libzzip-dev libfreeimage-dev libfreetype6-dev libpugixml-dev -y
cd ~/raisim_ws
git clone https://github.com/leggedrobotics/ogre.git
cd ogre
git checkout raisimOgre
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DOGRE_BUILD_COMPONENT_BITES=ON -OGRE_BUILD_COMPONENT_JAVA=OFF -DOGRE_BUILD_DEPENDENCIES=OFF -DOGRE_BUILD_SAMPLES=False
make install -j8

#installation for raimsimOrge
cd ~/raisim_ws
git clone https://github.com/leggedrobotics/raisimOgre.git
cd raisimOgre && mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$LOCAL_BUILD -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DRAISIM_OGRE_EXAMPLES=ON
make install -j8

#installation for pybind11
sudo apt-get install libyaml-cpp-dev -y
sudo apt-get install python3-pip -y
pip3 install tensorflow-gpu
cd ~/raisim_ws
git clone https://github.com/pybind/pybind11.git
cd pybind11 && git checkout v2.4.3 && mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_BUILD -DPYBIND11_TEST=OFF
make install -j4

#installation for raimsimGym
cd ~/raisim_ws
git clone https://github.com/leggedrobotics/raisimGym.git
cd raisimGym
python3 setup.py install --CMAKE_PREFIX_PATH $LOCAL_BUILD --env $WORKSPACE/raisimGym/raisim_gym/env/env/ANYmal/

