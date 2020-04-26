### NEXTCLOUD DOCKERFILE
###
##START
FROM php:7.4-apache

# entrypoint.sh and cron.sh dependencies - persistant!
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        rsync \
        bzip2 \
        busybox-static \
        sudo \
        smbclient \
### msmtp Installation
        msmtp \
        msmtp-mta \
        bsd-mailx \
        mailutils \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    mkdir -p /var/spool/cron/crontabs; \
    echo '*/15 * * * * php -f /var/www/html/cron.php' > /var/spool/cron/crontabs/www-data

# install the PHP extensions we need
# see https://docs.nextcloud.com/server/stable/admin_manual/installation/source_installation.html
RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libevent-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libmagickwand-dev \
        libzip-dev \
        libwebp-dev \
        libgmp-dev \
    ; \
    \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    if [ ! -e /usr/include/gmp.h ]; then ln -s /usr/include/$debMultiarch/gmp.h /usr/include/gmp.h; fi;\
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-configure gmp; \
    docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
    docker-php-ext-install -j "$(nproc)" \
        exif \
        gd \
        intl \
        ldap \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        zip \
        gmp \
    ; \
    \
# pecl will claim success even if one install fails, so we need to perform each install separately
    pecl install APCu; \
    pecl install memcached; \
    pecl install redis; \
    pecl install imagick; \
    \
    docker-php-ext-enable \
        apcu \
        memcached \
        redis \
        imagick \
    ; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=50000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini
#
## File Upload auf 4G und Memory-Limits auf 1024M hochschieben. PHP Execution Timeout auf 60m (3600s)
RUN     { \
        echo 'file_uploads = On'; \
        echo 'upload_max_filesize = 4G'; \
        echo 'post_max_size = 4G'; \
        echo 'memory_limit = 1024M'; \
        echo 'max_execution_time = 3600'; \
        echo 'default_socket_timeout = 3600'; \
        } > /usr/local/etc/php/conf.d/upload-limits.ini; \
    \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini; \
    \
    mkdir /var/www/data; \
    chown -R www-data:root /var/www; \
    chmod -R g=u /var/www

VOLUME /var/www/html

RUN a2enmod rewrite remoteip headers;\
    {\
        echo RemoteIPHeader X-Real-IP ;\
        echo RemoteIPTrustedProxy 10.0.0.0/8 ;\
        echo RemoteIPTrustedProxy 172.16.0.0/12 ;\
        echo RemoteIPTrustedProxy 192.168.0.0/16 ;\
    } > /etc/apache2/conf-available/remoteip.conf;\
    a2enconf remoteip

ENV NEXTCLOUD_VERSION 18.0.3

RUN set -ex; \
    fetchDeps=" \
        gnupg \
        dirmngr \
    "; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    \
    curl -fsSL -o nextcloud.tar.bz2 \
        "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2"; \
    curl -fsSL -o nextcloud.tar.bz2.asc \
        "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
# gpg key from https://nextcloud.com/nextcloud.asc
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys 28806A878AE423A28372792ED75899B9A724937A; \
    gpg --batch --verify nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    tar -xjf nextcloud.tar.bz2 -C /usr/src/; \
    gpgconf --kill all; \
    rm -r "$GNUPGHOME" nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    rm -rf /usr/src/nextcloud/updater; \
    mkdir -p /usr/src/nextcloud/data; \
    mkdir -p /usr/src/nextcloud/custom_apps; \
    chmod +x /usr/src/nextcloud/occ; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $fetchDeps; \
    rm -rf /var/lib/apt/lists/*

### msmtp CONFIG Block
## "sendmail"-Pfad auf "ssmtp" umbiegen
RUN    { \
        echo 'sendmail_path = /usr/bin/msmtp -t -C /etc/msmtprc'; \
    } > /usr/local/etc/php/conf.d/sendmail.ini
## msmtp und SMTP-Postfach konfigurieren
RUN { \
        echo '# Set defaults.'; \
        echo 'defaults'; \
        echo 'logfile /var/log/msmtp.log'; \
        echo '# Enable or disable TLS/SSL encryption.'; \
        echo 'tls on'; \
        echo 'tls_starttls on'; \
        echo 'tls_certcheck off'; \
        echo '# Setup mail to send emails via SMTP'; \
        echo 'account mail'; \
        echo 'host smtp.gmail.com'; \
        echo 'port 587'; \
        echo 'auth login'; \
        echo 'user eddie.faf@gmail.com'; \
        echo 'from eddie.faf@gmail.com'; \
        echo 'password ahvsqakkrewzxqby'; \
        echo '# Set a default account'; \
        echo 'account default : mail'; \
} > /etc/msmtprc \
&& chmod 600 /etc/msmtprc && chown www-data:www-data /etc/msmtprc

COPY *.sh upgrade.exclude /
COPY config/* /usr/src/nextcloud/config/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
##EOF

