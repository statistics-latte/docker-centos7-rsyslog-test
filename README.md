# docker-centos7-rsyslog-test
Docker rsyslog test (on CentOS 7.6)

```
# Build image
docker build -t centos7-rsyslog-test .

# Run container
docker run --rm -e TZ=Asia/Tokyo --name docker-centos7-rsyslog-test -ti docker-centos7-rsyslog-test /bin/bash

# --- container ---

# Start rsyslogd
sudo /usr/sbin/rsyslogd

# Check if rsyslogd is started. 
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    1 docker    20   0   14388   3604   3188 S   0.0  0.0   0:00.11 bash
   26 root      20   0  172352   2396   1988 S   0.0  0.0   0:00.08 rsyslogd
   35 docker    20   0   58736   4308   3776 R   0.0  0.1   0:00.00 top

# Check if log file is created as the ordinary user's file.
logger -p local0.error "test"; ll /home/docker
echo "--------"; cat /home/docker/rsyslog-test.log

# exit
exit
```
