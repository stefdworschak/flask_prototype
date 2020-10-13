FROM gitpod/workspace-full

USER root

RUN apt-get update -y
RUN apt-get -y install links
RUN apt-get install -y mysql-server
RUN apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*
RUN mkdir /var/run/mysqld
RUN chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade
RUN pip3 install flake8 flake8-flask flake8-django

# Create our own config files

COPY .theia/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

COPY .theia/client.cnf /etc/mysql/mysql.conf.d/client.cnf

COPY .theia/start_mysql.sh /etc/mysql/mysql-bashrc-launch.sh

USER gitpod

# Start MySQL when we log in
RUN echo ". /etc/mysql/mysql-bashrc-launch.sh" >> ~/.bashrc

# Local environment variables
# C9USER is temporary to allow the MySQL Gist to run
ENV C9_USER="gitpod"
ENV PORT="8080"
ENV IP="0.0.0.0"
ENV C9_HOSTNAME="localhost"

ENV ADDITIONAL_MYSQL_USER="test_user"
ENV ADDITIONAL_MYSQL_USER_PASSWORD="example"

USER root
# Switch back to root to allow IDE to load