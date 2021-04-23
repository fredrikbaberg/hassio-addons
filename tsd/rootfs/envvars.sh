# The following should be allowed to be set
export EMAIL_HOST='%%EMAIL_HOST%%' # -> such as 'smtp.gmail.com'
export EMAIL_HOST_USER='%%EMAIL_HOST_USER%%' # -> such as your email address for a Gmail account
export EMAIL_HOST_PASSWORD='%%EMAIL_HOST_PASSWORD%%' # -> your email account password
export EMAIL_PORT=%%EMAIL_PORT%%  # DO NOT surround it with quotes. Otherwise email won't be sent!
export EMAIL_USE_TLS='%%EMAIL_USE_TLS%%'
export DEFAULT_FROM_EMAIL='%%DEFAULT_FROM_EMAIL%%'
export SOCIAL_LOGIN='%%SOCIAL_LOGIN%%'
export ACCOUNT_ALLOW_SIGN_UP='%%ACCOUNT_ALLOW_SIGN_UP%%'  # -> set to 'True' if you want to open sign up form
export WEBPACK_LOADER_ENABLED='%%WEBPACK_LOADER_ENABLED%%'
export TWILIO_ACCOUNT_SID='%%TWILIO_ACCOUNT_SID%%'
export TWILIO_AUTH_TOKEN='%%TWILIO_AUTH_TOKEN%%'
export TWILIO_FROM_NUMBER='%%TWILIO_FROM_NUMBER%%'
export ML_API_TOKEN='%%ML_API_TOKEN%%'
export SENTRY_DSN='%%SENTRY_DSN%%'
export TELEGRAM_BOT_TOKEN='%%TELEGRAM_BOT_TOKEN%%'
export PUSHOVER_APP_TOKEN='%%PUSHOVER_APP_TOKEN%%'


# The following should not be changed
export DEBUG='False'    # Don't set DEBUG to True, otherwise the static files will be cached in browser until hard-refresh
export REDIS_URL='redis://localhost:6379'
export DATABASE_URL='sqlite:////data/db.sqlite3'
export INTERNAL_MEDIA_HOST='http://localhost:3334'
export ML_API_HOST='http://localhost:3333'
export SITE_USES_HTTPS='False' # set it to 'True' if https is set up
