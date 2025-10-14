#!/bin/bash
# Compile Phonetisaurus for amd64, armhf arm64 arch's.
git clone https://github.com/NietteLabs/Phonetisaurus
sudo apt install gcc-13-multilib gcc-13-arm-linux-gnueabihf gcc-13-aarch64-linux-gnu gcc-13-x86-64-linux-gnu gcc-13 g++-13-multilib g++-13-aarch64-linux-gnu g++-13-arm-linux-gnueabihf g++-13-x86-64-linux-gnu
for i in arm64 armhf amd64; do
sudo dpkg-deb -X libfst-dev/libfst-dev_1.8.4-3_$i.deb prefix_$i/
sudo dpkg-deb -X libfst26/libfst26_1.8.4-3_$i.deb prefix_$i/
sudo mkdir prefix_$i/usr/local/ -p
sudo mv prefix_$i/usr/include prefix_$i/usr/local/
sudo mv prefix_$i/usr/lib prefix_$i/usr/local/
sudo mv prefix_$i/usr/share prefix_$i/usr/local/
case "$i" in
    amd64)
        arch_bin="x86_64-linux-gnu"
        ;;
    armhf)
        arch_bin="arm-linux-gnueabihf"
        ;;
    arm64)
        arch_bin="aarch64-linux-gnu"
        ;;
  esac

cd Phonetisaurus/
make clean
./configure --host=$arch_bin CC=$arch_bin-gcc-13 CXX=$arch_bin-g++-13 AR=$arch_bin-ar --with-openfst-includes=$PWD/../prefix_$i/usr/local/include --with-openfst-libs=$PWD/../prefix_$i/usr/local/lib/$arch_bin --prefix=$PWD/../prefix_$i/usr/local/ --enable-static --disable-shared
make -j$(nproc)
sudo make install
cd ../

sudo cp -r DEBIAN/ prefix_$i/
sudo sed "s/arch_bin/$i/g" prefix_$i/DEBIAN/control -i
sudo dpkg-deb --root-owner-group -b prefix_$i "$i".deb

done


