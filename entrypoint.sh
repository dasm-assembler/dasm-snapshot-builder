#!/bin/sh -l

# timestamp to use in name of snapshot builds
timestamp=$(date '+%Y%m%d%H%M%S')

# setup git user
git config --global user.email "automated.build@dasm.com"
git config --global user.name "automated build"

# clone dasm branch
git clone --single-branch --branch $1 https://$2:$3@github.com/dasm-assembler/dasm.git

# build dasm binaries for all platforms
cd dasm/docker
./make_dasm_all_platforms.sh

# create empty snapshot-builds folder
cd ..
rm -r snapshot-builds
mkdir snapshot-builds

# create package folders for all platforms and tar gz 'm up
mkdir -p bin/dasm-$timestamp-linux-x64
mkdir -p bin/dasm-$timestamp-linux-x86
mkdir -p bin/dasm-$timestamp-osx-x64
mkdir -p bin/dasm-$timestamp-osx-x86
mkdir -p bin/dasm-$timestamp-win-x64
mkdir -p bin/dasm-$timestamp-win-x86

cp -a machines/ bin/dasm-$timestamp-linux-x64/
cp -a machines/ bin/dasm-$timestamp-linux-x86/
cp -a machines/ bin/dasm-$timestamp-osx-x64/
cp -a machines/ bin/dasm-$timestamp-osx-x86/
cp -a machines/ bin/dasm-$timestamp-win-x64/
cp -a machines/ bin/dasm-$timestamp-win-x86/

cp -a bin/64bit/dasm.Linux bin/dasm-$timestamp-linux-x64/dasm
cp -a bin/32bit/dasm.Linux bin/dasm-$timestamp-linux-x86/dasm
cp -a bin/64bit/dasm.macOS bin/dasm-$timestamp-osx-x64/dasm
cp -a bin/32bit/dasm.macOS bin/dasm-$timestamp-osx-x86/dasm
cp -a bin/64bit/dasm.exe bin/dasm-$timestamp-win-x64/dasm.exe
cp -a bin/32bit/dasm.exe bin/dasm-$timestamp-win-x86/dasm.exe

cd bin/dasm-$timestamp-linux-x64
tar -zcvf ../../snapshot-builds/dasm-$timestamp-linux-x64.tar.gz *
cd ../dasm-$timestamp-linux-x86
tar -zcvf ../../snapshot-builds/dasm-$timestamp-linux-x86.tar.gz *
cd ../dasm-$timestamp-osx-x64
tar -zcvf ../../snapshot-builds/dasm-$timestamp-osx-x64.tar.gz *
cd ../dasm-$timestamp-osx-x86
tar -zcvf ../../snapshot-builds/dasm-$timestamp-osx-x86.tar.gz *
cd ../dasm-$timestamp-win-x64
tar -zcvf ../../snapshot-builds/dasm-$timestamp-win-x64.tar.gz *
cd ../dasm-$timestamp-win-x86
tar -zcvf ../../snapshot-builds/dasm-$timestamp-win-x86.tar.gz *

# cd back to dasm root
cd ../..

# add the snapshots builds
git add snapshot-builds/.

# commit and push back to branch
git commit -m "Added snapshot builds - $timestamp"
git push origin $1
