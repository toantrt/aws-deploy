#!/bin/bash
#######################################################################
# System preparation following successful application installation.
#######################################################################

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CRONTAB_PATH=/var/spool/cron/crontabs/www-data

# Setup www-data crontab
cp ${SCRIPT_PATH}/crontab ${CRONTAB_PATH} && chown www-data.crontab ${CRONTAB_PATH} && chmod 600 ${CRONTAB_PATH}

# Bring in the SSL configuration and prep it
mv /var/www/config/ssl/*.* /etc/ssl/
(cd /etc/ssl && cat example.com.crt example.com.ca-bundle > example.com.chained.crt)

# Copy nginx configuration
cp ${SCRIPT_PATH}/mwop.net.conf /etc/nginx/sites-available/
if [ ! -e "/etc/nginx/sites-enabled/example.com.conf" ];then
    (cd /etc/nginx/sites-enabled && ln -s ../sites-available/example.com.conf .)
fi

# Copy php configuration for php-fpm process
cp ${SCRIPT_PATH}/php.ini /etc/php/7.0/fpm/conf.d/example.com.ini
cp ${SCRIPT_PATH}/php-fpm.conf /etc/php/7.0/fpm/pool.d/www.conf
