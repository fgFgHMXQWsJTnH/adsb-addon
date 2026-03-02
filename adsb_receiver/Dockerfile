ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && apt-get install -y --no-install-recommends \
    libusb-1.0-0 \
    librtlsdr0 \
    && rm -rf /var/lib/apt/lists/*

COPY bin/dump1090-mutability /usr/local/bin/dump1090-mutability
RUN chmod +x /usr/local/bin/dump1090-mutability

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
