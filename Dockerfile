FROM php:5.6-apache

# Install/configure PHP, Apache and other dependencies.
RUN mkdir -p /var/www/html \
    && apt-get update \
    && apt-get install -y wget vim sudo gnupg net-tools libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg62-turbo libfreetype6-dev libpng-dev libjpeg62-turbo-dev default-mysql-client libxml2-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install soap \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install xml \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apt-get purge --auto-remove -y libpng12-dev libmcrypt-dev libcurl3-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev \
    && rm -rf /var/lib/apt/lists/*

# Create Self Signed Certificate
RUN mkdir -p /etc/ssl/certs
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=US/ST=Texas/L=San Antonio/O=MageBR/OU=Docker Magento 1/CN=magebr.com"

# Setup Apache.
RUN usermod -u 1000 www-data \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2enmod status \
    && a2ensite default-ssl \
    && a2enmod ssl

# Copy configuration into the container.
COPY resources/ /

# Remove .git directory.
RUN rm -rf /var/www/html/.git

WORKDIR /
# CMD ['']
