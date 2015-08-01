FROM php:5.6-cli
# Prepare basic deps
RUN apt-get update && apt-get install -y  apt-utils wget curl build-essential

# Install PHP5.6
RUN pecl config-set preferred_state alpha

# allow manipulation with ENV variables
RUN touch /usr/local/etc/php/php.ini
# Install PHP Curl
RUN pecl install curl  && echo "extension=curl.so" > /usr/local/etc/php/conf.d/curl.ini

# Install PHP Libevent
RUN apt-get install libevent libevent-dev && pecl install libevent && echo "extension=libevent.so" > /usr/local/etc/php/conf.d/libevent.ini

# Install ZeroMQ
RUN apt-get install -y libzmq3-dev
RUN pecl install zmq-beta && echo "extension=zmq.so" > /usr/local/etc/php/conf.d/zeromq.ini

#Install PHP Zip
RUN cd /usr/local/src && wget http://zlib.net/zlib-1.2.8.tar.gz && tar -xvzf zlib-1.2.8.tar.gz && rm *.gz && cd zlib-1.2.8 && ./configure && make && make install && docker-php-ext-install zip

RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/usr/local/lib --filename=composer 
