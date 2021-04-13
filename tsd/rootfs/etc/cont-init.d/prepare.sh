#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare cont-init.d"

if [ ! -d /data/web ]; then
    cp -R /web /data/
fi

if [ ! -d /data/app ]; then
    cp -R /app /data/
fi

if [ ! -f /data/app/model/model.weights ]; then
    # bashio::log.info "Downloading model weights"
    cd /data/app && wget --quiet -O model/model.weights $(cat model/model.weights.url | tr -d '\r')
    sed -i "s#/app/#/data/app/#g" /data/app/model/model.meta
fi

cd /data/web && python manage.py collectstatic --noinput
