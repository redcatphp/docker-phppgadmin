FROM debian:stretch

MAINTAINER Jo 'Redcat Ninja' <jo@redcat.ninja>

ENV DEBIAN_FRONTEND=noninteractive
# Add the PostgreSQL apt repository
RUN apt-get update && \
    apt-get -y install wget gnupg && \
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install apache2 libapache2-mod-php php php-pgsql unzip postgresql-client && \
    apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV PORT=5432
ENV HOST=database

WORKDIR /var/www/html

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
  && ln -sf /dev/stdout /var/log/apache2/error.log \
  && chown -R www-data:www-data /var/log/apache2 /var/www/html \
  #&& wget https://github.com/phppgadmin/phppgadmin/archive/master.zip \
  && wget https://github.com/scottdriscoll/phppgadmin/archive/82269f9d0769d25df9dc2742ae489f35323a3453.zip \
  && rm /var/www/html/index.html && unzip /var/www/html/82269f9d0769d25df9dc2742ae489f35323a3453.zip \
  && cp -R phppgadmin-82269f9d0769d25df9dc2742ae489f35323a3453/* . && rm -r phppgadmin-82269f9d0769d25df9dc2742ae489f35323a3453 \
  && rm /var/www/html/82269f9d0769d25df9dc2742ae489f35323a3453.zip \
  && rm -rf /var/lib/apt/lists/*

ADD config.inc.php /var/www/html/conf/config.inc.php

ADD run.sh /run.sh

RUN chmod -v +x /run.sh

EXPOSE 80

CMD ["/run.sh"]
