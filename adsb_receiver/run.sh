#!/usr/bin/with-contenv bashio

SERIAL=$(bashio::config 'serial')
LAT=$(bashio::config 'lat')
LON=$(bashio::config 'lon')
GAIN=$(bashio::config 'gain')

bashio::log.info "Looking for RTL-SDR device with serial: ${SERIAL}"

# Disable exit-on-error while we run the device probe
set +e
DUMP_OUTPUT=$(dump1090-mutability --device-index 99 2>&1)
set -e

bashio::log.info "Device probe output: ${DUMP_OUTPUT}"

DEVICE_INDEX=$(echo "${DUMP_OUTPUT}" | grep "SN: ${SERIAL}" | awk '{print $1}' | tr -d ':')

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
# Create JSON output directory before lighttpd starts (fixes 404)
mkdir -p /tmp/dump1090-json

cat > /tmp/lighttpd.conf << 'EOF'
server.modules += ( "mod_dirlisting" )
server.document-root = "/tmp/dump1090-json"
server.port = 8080
server.bind = "0.0.0.0"
mimetype.assign = ( ".json" => "application/json" )
dir-listing.activate = "enable"
EOF

lighttpd -f /tmp/lighttpd.conf
bashio::log.info "lighttpd started on port 8080, serving /tmp/dump1090-json"

exec dump1090-mutability \
    --device-index ${DEVICE_INDEX} \
    --lat "${LAT}" \
    --lon "${LON}" \
    ${GAIN_ARG} \
    --net \
    --net-bind-address 0.0.0.0 \
    --write-json /tmp/dump1090-json \
    --write-json-every 1 \
    --quiet
