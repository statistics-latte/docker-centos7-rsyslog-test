FROM centos:7.6.1810

#ENV TZ=Asia/Tokyo

# Install packages
#   epel-release for supervisor.
RUN yum -y update \
  && yum install -y epel-release \
  && yum -y update \
  && yum install -y sudo vim less rsyslog supervisor \
  && rm -rf /var/cache/yum/* \
  && yum clean all

RUN mkdir -p /var/log/supervisor

# Create ordinary user (can use sudo without password)
ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
RUN useradd --uid ${DOCKER_UID} --create-home --shell /bin/bash -G wheel,root ${DOCKER_USER}
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Timezone
# Use "-e TZ=Asia/Tokyo" option in docker run command. 

# Set locale (Japanese)
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# CentOS7 Logging:
#   /dev/log -> journal -> rsyslog -> /var/log/message
# but... in Container, journal is not running.
# Change logging stream as
#   /dev/log -> rsyslog -> /var/log/message

# sed (stream editor) options:
#  -i (--in-place)
#  -e script (--expression=script)

# Don't use systemd journal
RUN sed -i -e '/^\$SystemLogSocketName.*/s/^/# /' /etc/rsyslog.d/listen.conf \
  && sed -i -e '/^\$ModLoad imjournal.*/s/^/# /' /etc/rsyslog.conf \
  && sed -i -e 's/OmitLocalLogging on/OmitLocalLogging off/' /etc/rsyslog.conf \
  && sed -i -e '/^\$IMJournalStateFile imjournal\.state/s/^/# /' /etc/rsyslog.conf

COPY rsyslog-test.conf /etc/rsyslog.d/

# supervisord
COPY supervisord.conf /etc/supervisord.conf

USER docker
WORKDIR /home/docker

CMD ["sudo", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
