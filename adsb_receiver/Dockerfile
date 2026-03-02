ARG BUILD_FROM

# Pull dump1090-fa binary and web files from pre-built image
# This avoids needing git/cmake/make at build time
FROM ghcr.io/sdr-enthusiasts/docker-dump1090-fa:latest AS dump1090_source

FROM $BUILD_FROM

# Copy dump1090 binary and web assets from pre-built image
COPY --from=dump1090_source /usr/local/bin/dump1090 /usr/local/bin/dump1090
COPY --from=dump1090_source /usr/local/share/dump1090-fa /usr/local/share/dump1090-fa

# Install runtime dependencies only (no git, no compilation)
RUN apk add --no-cache libusb rtl-sdr bash

# Copy run script
COPY run.sh /
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
