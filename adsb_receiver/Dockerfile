ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache bash libusb rtl-sdr

# Copy pre-built binary - no internet needed at build time
COPY bin/dump1090-mutability /usr/local/bin/dump1090-mutability
RUN chmod +x /usr/local/bin/dump1090-mutability

# Copy s6 service
COPY rootfs /
RUN chmod a+x /etc/s6-overlay/s6-rc.d/adsb/run
