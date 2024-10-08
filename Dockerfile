FROM dunglas/frankenphp

# Be sure to replace "your-domain-name.example.com" by your domain name
# ENV SERVER_NAME=systom.com.br
# If you want to disable HTTPS, use this value instead:
ENV SERVER_NAME=:80

# Install dependences
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    unzip \
    librabbitmq-dev \
    libpq-dev \
    supervisor

# Copy the PHP files of your project in the public directory
# COPY . /app/public
# If you use Symfony or Laravel, you need to copy the whole project instead:
COPY . /app

# Install extensions
RUN install-php-extensions \
    gd \
    pcntl \
    opcache \
    pdo \
    pdo_mysql \
    redis

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy php.ini config
COPY ./docker/php/php.ini /usr/local/etc/php/

# Install Laravel dependencies using Composer.
RUN composer install