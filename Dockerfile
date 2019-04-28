FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV TZ Europe/Warsaw

ENV APP python
ENV APP_REV 3.7
ENV APP_VERSION $APP$APP_REV

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -q -y --no-install-recommends install psmisc curl wget git less vim net-tools lsof iproute2 tzdata build-essential
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/fkrull-deadsnakes.list
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv F23C5A6CF475977595C89F51BA6932366A755776
RUN apt-get update; apt-get -y --no-install-recommends install python3-distutils $APP_VERSION $APP_VERSION-dev $APP_VERSION-venv
RUN curl https://bootstrap.pypa.io/get-pip.py | $APP_VERSION -
RUN rm -f /usr/bin/python && ln -s /usr/bin/$APP_VERSION /usr/bin/python
RUN rm -f /usr/bin/python3 && ln -s /usr/bin/$APP_VERSION /usr/bin/python3
RUN pip3 install ipython virtualenvwrapper

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# disable cron service
RUN touch /etc/service/cron/down
# remove sshd service
RUN rm -rf /etc/service/sshd

WORKDIR /opt
CMD ["/sbin/my_init"]
