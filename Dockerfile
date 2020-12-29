FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV SNOWMIX_VERSION=0.5.1.1
ENV SNOWMIX=/usr/local/lib/snowmix

# Install Packages
RUN apt update && apt install -y \
    build-essential \
    automake \
    make \
    autoconf \
    libtool \
    g++ \
    pkg-config \
    bc \
    libpng-dev \
    libsdl1.2-dev \
    libpango1.0-dev \
    tcl-dev \
    tcl \
    tk \
    bwidget \
    libosmesa6-dev \
    liborc-0.4-dev \
    freeglut3-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-doc \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio \
    libgstreamer1.0-0 \
    libglew-dev \
    netcat \
    git \
    curl \
    wget

RUN cd /tmp && \
    wget https://downloads.sourceforge.net/project/snowmix/Snowmix-${SNOWMIX_VERSION}.tar.gz && \
    tar xvfz Snowmix-${SNOWMIX_VERSION}.tar.gz && \
    mv Snowmix-${SNOWMIX_VERSION} ${SNOWMIX} && \
    cd ${SNOWMIX} && \
    mkdir -p /usr/share/fonts/truetype/ && \
    cp ./fonts/Eurosti.ttf /usr/share/fonts/truetype/ && \
    ./bootstrapd/bootstrap-ubuntu && \
    mkdir m4 && \
    aclocal && \
    autoconf && \
    libtoolize --force && \
    automake --add-missing && \
    ./configure --prefix=${SNOWMIX} && \
    make && \
    make install && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

HEALTHCHECK --interval=1m --timeout=3s CMD nc -q 1 127.0.0.1 9999 || exit 1

WORKDIR ${SNOWMIX}

CMD [ "./bin/snowmix", "ini/minimal" ]
