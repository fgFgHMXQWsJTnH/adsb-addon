ARG BUILD_FROM
FROM $BUILD_FROM

# Enable Alpine community repo (dump1090 lives there, not in main)
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.21/community" >> /etc/apk/repositories && \
    apk update

# Install dump1090 and rtl-sdr directly from Alpine package repo
# No git cloning, no compilation, no external images needed
RUN apk add --no-cache \
    bash \
    libusb \
    rtl-sdr \
    dump1090

# Copy run script
COPY run.sh /
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
