#!/bin/sh

# install wget, which is cleverer than curl
# curl -O http://ftp.gnu.org/gnu/wget/wget-1.11.tar.gz
# tar zxvf wget-1.11.tar.gz 
# cd wget-1.11
# ./configure --prefix=/usr/local
# make
# sudo make install
# cd /usr/local/src

# prerequisite packages
curl -O http://nongnu.askapache.com/freetype/freetype-2.3.9.tar.gz
tar zxvf freetype-2.3.9.tar.gz
cd freetype-2.3.9
./configure --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/libpng-1.2.40.tar.gz
tar zxvf libpng-1.2.40.tar.gz
cd libpng-1.2.40.tar.gz
./configure --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/jpegsrc.v7.tar.gz
tar xzvf jpegsrc*
cd jpeg*
ln -s `which glibtool` ./libtool
export MACOSX_DEPLOYMENT_TARGET=10.6
./configure --enable-shared --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/tiff-3.9.1.tar.gz
tar xzvf tiff-3.9.1.tar.gz
cd tiff-3.9.1
./configure --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/libwmf-0.2.8.4.tar.gz
tar xzvf libwmf-0.2.8.4.tar.gz
cd libwmf-0.2.8.4
./configure --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/lcms-1.19.tar.gz
tar xzvf lcms-1.19.tar.gz
cd lcms-1.19
./configure --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/ghostscript-8.70.tar.gz
tar zxvf ghostscript-8.70.tar.gz
cd ghostscript-8.70
./configure  --prefix=/Users/seihe333/bin/usr/local
make
make install
cd ..

curl -O http://image_magick.veidrodis.com/image_magick/delegates/ghostscript-fonts-std-8.11.tar.gz
tar zxvf ghostscript-fonts-std-8.11.tar.gz
mv fonts /Users/seihe333/bin/usr/local/share/ghostscript

# Image Magick
curl -O ftp://ftp.fifi.org/pub/ImageMagick/ImageMagick.tar.gz
tar xzvf ImageMagick.tar.gz
export CPPFLAGS=-I/Users/seihe333/bin/usr/local/include
export LDFLAGS=-L/Users/seihe333/bin/usr/local/lib
./configure --prefix=/Users/seihe333/bin/usr/local --disable-static --with-modules --without-perl --without-magick-plus-plus --with-quantum-depth=8 --with-gs-font-dir=/usr/local/share/ghostscript/fonts --disable-openmp
make
make install
cd ..

# RMagick
gem install rmagick