#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare cont-init.d"

if [ ! -d /data/web ]; then
    cp -R /web /data/
fi

if [ ! -d /data/app ]; then
    cp -R /app /data/
fi

if [ ! -f /data/app/model/model.weights ]; then
    bashio::log.info "Downloading model weights"
    cd /data/app && wget --quiet -O model/model.weights $(cat model/model.weights.url | tr -d '\r')
    sed -i "s#/app/#/data/app/#g" /data/app/model/model.meta
fi

# Update environment variables based on configuration
sed -i "s#%%EMAIL_HOST%%#$(bashio::config 'EMAIL_HOST')#g" /envvars.sh
sed -i "s#%%EMAIL_HOST_USER%%#$(bashio::config 'EMAIL_HOST_USER')#g" /envvars.sh
sed -i "s#%%EMAIL_HOST_PASSWORD%%#$(bashio::config 'EMAIL_HOST_PASSWORD')#g" /envvars.sh
sed -i "s#%%EMAIL_PORT%%#$(bashio::config 'EMAIL_PORT')#g" /envvars.sh
sed -i "s#%%EMAIL_USE_TLS%%#$(bashio::config 'EMAIL_USE_TLS')#g" /envvars.sh
sed -i "s#%%DEFAULT_FROM_EMAIL%%#$(bashio::config 'DEFAULT_FROM_EMAIL')#g" /envvars.sh
sed -i "s#%%SOCIAL_LOGIN%%#$(bashio::config 'SOCIAL_LOGIN')#g" /envvars.sh
sed -i "s#%%ACCOUNT_ALLOW_SIGN_UP%%#$(bashio::config 'ACCOUNT_ALLOW_SIGN_UP')#g" /envvars.sh
sed -i "s#%%WEBPACK_LOADER_ENABLED%%#$(bashio::config 'WEBPACK_LOADER_ENABLED')#g" /envvars.sh
sed -i "s#%%TWILIO_ACCOUNT_SID%%#$(bashio::config 'TWILIO_ACCOUNT_SID')#g" /envvars.sh
sed -i "s#%%TWILIO_AUTH_TOKEN%%#$(bashio::config 'TWILIO_AUTH_TOKEN')#g" /envvars.sh
sed -i "s#%%TWILIO_FROM_NUMBER%%#$(bashio::config 'TWILIO_FROM_NUMBER')#g" /envvars.sh
sed -i "s#%%ML_API_TOKEN%%#$(bashio::config 'ML_API_TOKEN')#g" /envvars.sh
sed -i "s#%%SENTRY_DSN%%#$(bashio::config 'SENTRY_DSN')#g" /envvars.sh
sed -i "s#%%TELEGRAM_BOT_TOKEN%%#$(bashio::config 'TELEGRAM_BOT_TOKEN')#g" /envvars.sh
sed -i "s#%%PUSHOVER_APP_TOKEN%%#$(bashio::config 'PUSHOVER_APP_TOKEN')#g" /envvars.sh

cd /data/web && python manage.py collectstatic --noinput
