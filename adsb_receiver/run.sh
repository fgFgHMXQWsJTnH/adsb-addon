#!/usr/bin/env bash
set -e

# Read config options
SERIAL=$(bashio::config 'serial')
LAT=$(bashio::config 'lat')
LON=$(bashio::config 'lon')
GAIN=$(bashio::config 'gain')

bashio::log.info "Starting dump1090 on serial: ${SERIAL}"
bashio::log.info "Location: ${LAT}, ${LON}"
bashio::log.info "Gain: ${GAIN}"

# Build gain argument
if [ "${GAIN}" = "auto" ]; then
    GAIN_ARG="--gain -10"
else
    GAIN_ARG="--gain ${GAIN}"
fi

# Run dump1090
exec dump1090 \
    --device-index ":${SERIAL}" \
    --lat "${LAT}" \
    --lon "${LON}" \
    ${GAIN_ARG} \
    --net \
    --net-http-port 8080 \
    --net-ro-port 30002 \
    --net-ri-port 30001 \
    --net-bo-port 30005 \
    --net-bi-port 30004 \
    --write-json /tmp/dump1090-json \
    --write-json-every 1 \
    --quiet
