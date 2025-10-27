# RisolviAmoSubito Web Server Dockerfile
# PHP 8.2 with Apache, optimized for production

FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libxslt-dev \
    unzip \
    git \
    wget \
    curl \
    nano \
    cron \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        zip \
        pdo \
        pdo_mysql \
        mysqli \
        intl \
        xml \
        curl \
        bz2 \
        readline \
        xsl \
        bcmath \
        opcache

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Configure Apache
RUN a2enmod rewrite ssl headers expires deflate

# PHP configuration for production
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=512'; \
    echo 'opcache.interned_strings_buffer=64'; \
    echo 'opcache.max_accelerated_files=32531'; \
    echo 'opcache.validate_timestamps=0'; \
    echo 'opcache.save_comments=1'; \
    echo 'opcache.fast_shutdown=0'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
    echo 'memory_limit=256M'; \
    echo 'upload_max_filesize=10M'; \
    echo 'post_max_size=10M'; \
    echo 'max_execution_time=60'; \
    echo 'max_input_vars=3000'; \
    echo 'date.timezone=Europe/Rome'; \
    echo 'log_errors=On'; \
    echo 'error_log=/var/www/html/logs/php_errors.log'; \
    echo 'display_errors=Off'; \
    echo 'display_startup_errors=Off'; \
    } > /usr/local/etc/php/conf.d/risolviamosubito.ini

# Session configuration
RUN { \
    echo 'session.cookie_httponly=1'; \
    echo 'session.cookie_secure=1'; \
    echo 'session.cookie_samesite=Strict'; \
    echo 'session.use_strict_mode=1'; \
    echo 'session.gc_maxlifetime=604800'; \
    } > /usr/local/etc/php/conf.d/session.ini

# Copy Apache configuration
COPY docker/web/apache.conf /etc/apache2/sites-available/000-default.conf

# Copy supervisor configuration
COPY docker/web/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories
RUN mkdir -p /var/www/html/logs \
    /var/www/html/uploads \
    /var/www/html/cache \
    /var/www/html/sessions \
    /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy application code
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/public \
    && chmod -R 777 /var/www/html/logs \
    && chmod -R 777 /var/www/html/uploads \
    && chmod -R 777 /var/www/html/cache \
    && chmod -R 777 /var/www/html/sessions \
    && chmod +x /var/www/html/deploy.sh

# Expose ports
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]