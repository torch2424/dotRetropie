#/bin/bash

#https://github.com/mickelson/attract/wiki/Compiling-on-the-Raspberry-Pi-(Raspbian-Jessie)

cd ~
rm -rf develop
mkdir develop

sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg62-turbo-dev libfreetype6-dev  libudev-dev libfontconfig1-dev

cd ~/develop
git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
mkdir sfml-pi/build;cd sfml-pi/build
cmake .. -DSFML_RPI=1 -DEGL_INCLUDE_DIR=/opt/vc/include -DEGL_LIBRARY=/opt/vc/lib/libEGL.so -DGLES_INCLUDE_DIR=/opt/vc/include -DGLES_LIBRARY=/opt/vc/lib/libGLESv1_CM.so
sudo make install
sudo ldconfig

cd ~/develop
git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --enable-mmal --disable-debug --enable-shared
make -j4
sudo make install
sudo ldconfig

cd ~/develop
git clone --depth 1 https://github.com/mickelson/attract attract
cd attract
make USE_GLES=1 -j4
sudo make install
