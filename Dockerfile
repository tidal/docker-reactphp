FROM php:5.6-cli
# Prepare basic deps
RUN apt-get update && apt-get install -y  apt-utils wget curl build-essential

# Install PHP5.6
RUN pecl config-set preferred_state alpha

# allow manipulation with ENV variables
RUN touch /usr/local/etc/php/php.ini

# Install PHP Libevent
ENV LIBEVENT_VERSION 2.1.8
RUN cd /usr/local/src && wget https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION-stable/libevent-$LIBEVENT_VERSION-stable.tar.gz && tar -xvzf libevent-$LIBEVENT_VERSION-stable.tar.gz && rm *.gz && cd libevent-$LIBEVENT_VERSION-stable && ./configure && make && make install 
RUN pecl install libevent && echo "extension=libevent.so" > /usr/local/etc/php/conf.d/libevent.ini

# Install ZeroMQ
RUN apt-get install -y libzmq3-dev
RUN pecl install zmq-beta && echo "extension=zmq.so" > /usr/local/etc/php/conf.d/zeromq.ini

#Install PHP Zlib
ENV ZLIB_VERSION 1.2.11
RUN cd /usr/local/src && wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz && tar -xvzf zlib-$ZLIB_VERSION.tar.gz && rm *.gz && cd zlib-$ZLIB_VERSION && ./configure && make && make install && docker-php-ext-install zip

RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
