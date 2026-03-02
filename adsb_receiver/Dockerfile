ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache bash libusb rtl-sdr

COPY bin/dump1090-mutability /usr/local/bin/dump1090-mutability
RUN chmod +x /usr/local/bin/dump1090-mutability

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
