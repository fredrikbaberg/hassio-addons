#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare cont-init.d"

if [ ! -d /app ]; then
    cp -R /tsd/TheSpaghettiDetective/ml_api /app/
fi

if [ ! -d /data/web ]; then
    cp -R /tsd/TheSpaghettiDetective/web /data/
fi

if [ ! -f /app/model/model.weights ]; then
    bashio::log.info "Downloading model weights"
    cd /app && wget --quiet -O model/model.weights $(cat model/model.weights.url | tr -d '\r')
fi

cd /tsd/web && python manage.py collectstatic --noinput

# echo never > /sys/kernel/mm/transparent_hugepage/enabled
