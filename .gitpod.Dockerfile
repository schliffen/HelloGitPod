FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

ARG OPENCV_VERSION="3.0.0"

USER gitpod

# install dependencies
# RUN apt-get update
RUN apt-get install -y libopencv-dev yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils pkg-config

# USER gitpod
RUN apt-get install -y curl build-essential checkinstall cmake

#USER gitpod
# download opencv
RUN curl -sL https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.tar.gz | tar xvz -C /tmp
#USER gitpod
RUN mkdir -p /tmp/opencv-$OPENCV_VERSION/build

#USER gitpod
WORKDIR /tmp/opencv-$OPENCV_VERSION/build

#USER gitpod
# install
RUN cmake -DWITH_FFMPEG=OFF -DWITH_OPENEXR=OFF -DBUILD_TIFF=OFF -DWITH_CUDA=OFF -DWITH_NVCUVID=OFF -DBUILD_PNG=OFF ..
#USER gitpod
RUN make
#USER gitpod
RUN make install

# configure
#USER gitpod
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
#USER gitpod
RUN ldconfig
#USER gitpod
RUN ln /dev/null /dev/raw1394 # hide warning - http://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394

# cleanup package manager
#USER gitpod
RUN apt-get remove --purge -y curl build-essential checkinstall cmake
#USER gitpod
RUN apt-get autoclean && apt-get clean
#USER gitpod
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#USER gitpod
# prepare dir
RUN mkdir /source

VOLUME ["/source"]
WORKDIR /source
CMD ["bash"]