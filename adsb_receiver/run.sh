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
bashio::log.info "dump1090 html files: $(find /usr/share -name 'gmap.html' 2>/dev/null)"
cat > /tmp/lighttpd.conf << 'EOF'
server.document-root = "/usr/share/dump1090-mutability/html"
server.port = 8080
server.bind = "0.0.0.0"
alias.url += ( "/data/" => "/tmp/dump1090-json/" )
mimetype.assign = (
  ".html" => "text/html",
  ".js"   => "application/javascript",
  ".css"  => "text/css",
  ".json" => "application/json"
)
EOF

lighttpd -f /tmp/lighttpd.conf

exec dump1090-mutability \
    --device-index ${DEVICE_INDEX} \
    --lat "${LAT}" \
    --lon "${LON}" \
    ${GAIN_ARG} \
    --net \
    --net-http-port 8080 \
    --net-bind-address 0.0.0.0 \
    --write-json /tmp/dump1090-json \
    --write-json-every 1 \
    --quiet
