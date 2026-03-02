#!/usr/bin/with-contenv bashio
set -e

SERIAL=$(bashio::config 'serial')
LAT=$(bashio::config 'lat')
LON=$(bashio::config 'lon')
GAIN=$(bashio::config 'gain')

bashio::log.info "Looking for RTL-SDR device with serial: ${SERIAL}"

# Find the device index for our serial number
DEVICE_INDEX=$(rtl_test 2>&1 | grep -n "${SERIAL}" | head -1 | awk -F: '{print $1}')
DEVICE_INDEX=$((DEVICE_INDEX - 1))

if [ -z "${DEVICE_INDEX}" ]; then
    bashio::log.error "Could not find device with serial ${SERIAL}"
    exit 1
fi

bashio::log.info "Found device at index ${DEVICE_INDEX}, starting dump1090"

if [ "${GAIN}" = "auto" ]; then
    GAIN_ARG="--gain -10"
else
    GAIN_ARG="--gain ${GAIN}"
fi

exec dump1090-mutability \
    --device-index ${DEVICE_INDEX} \
    --lat "${LAT}" \
    --lon "${LON}" \
    ${GAIN_ARG} \
    --net \
    --write-json /tmp/dump1090-json \
    --write-json-every 1 \
    --quiet
