ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies
RUN apk add --no-cache \
    bash \
    libusb \
    libusb-dev \
    git \
    cmake \
    make \
    g++ \
    pkgconfig \
    ncurses-dev

# Build rtl-sdr from source
RUN git clone https://github.com/osmocom/rtl-sdr.git /tmp/rtl-sdr && \
    cd /tmp/rtl-sdr && \
    mkdir build && cd build && \
    cmake -DINSTALL_UDEV_RULES=ON -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/rtl-sdr

# Build dump1090-fa from source
RUN git clone https://github.com/flightaware/dump1090.git /tmp/dump1090 && \
    cd /tmp/dump1090 && \
    make -j$(nproc) BLADERF=no HACKRF=no LIMESDR=no && \
    cp dump1090 /usr/local/bin/ && \
    cp -r public_html /usr/local/share/dump1090-html && \
    rm -rf /tmp/dump1090

# Copy run script
COPY run.sh /
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
