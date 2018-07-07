FROM node:9.2

COPY . /var/laravel

WORKDIR /var/laravel

RUN npm install \
  && npm rebuild node-sass \
  && npm run production

RUN rm -rf ./node_modules

FROM php:7.2-fpm-alpine

# install libraries
RUN apk upgrade --update \
    && apk add \
       git \
       zlib-dev \
       nginx \
    && docker-php-ext-install pdo_mysql zip \
    && mkdir /run/nginx

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

ENV COMPOSER_ALLOW_SUPERUSER 1

# setting up apps
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=0 /var/laravel /var/www/laravel
WORKDIR /var/www/laravel

# install php libraries && compile laravel mix
RUN composer install --no-dev

RUN find ./vendor -iname tests -type d | xargs rm -rf \
    && find ./vendor -iname tests -type d | xargs rm -rf

COPY ./run.sh /usr/local/bin/run.sh

RUN chown nginx:nginx storage/logs \
    && sed -i 's/www-data/nginx/g' /usr/local/etc/php-fpm.d/www.conf \
    && chown -R nginx:nginx storage/framework \
    && cp .env.example .env \
    && php artisan key:generate \
    && mkdir -p  /usr/share/nginx \
    && ln -s /var/www/public /usr/share/nginx/html \
    && chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
