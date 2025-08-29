#!/bin/bash

# Git clone
git clone https://github.com/rhasspy/phonetisaurus-pypi/
mkdir g2p/
cp phonetisaurus-pypi/phonetisaurus/bin -r g2p/
cp phonetisaurus-pypi/phonetisaurus/lib -r g2p/

for arch in aarch64 armv7l x86_64; do
    echo $arch

    case "$arch" in
    x86_64)
        arch_bin="amd64"
        ;;
    armv7l)
        arch_bin="armhf"
        ;;
    aarch64)
        arch_bin="arm64"
        ;;
    esac

    mkdir deb_"$arch_bin"/usr/local/{bin,lib} -p
    cp g2p/bin/$arch/* deb_"$arch_bin"/usr/local/bin/
    cp g2p/lib/$arch/* deb_"$arch_bin"/usr/local/lib/
    cp -r DEBIAN/ deb_"$arch_bin"/

    sed "s/arch_bin/$arch_bin/g" DEBIAN/control >deb_$arch_bin/DEBIAN/control

    dpkg-deb --root-owner-group -b deb_$arch_bin "$arch_bin".deb

done
