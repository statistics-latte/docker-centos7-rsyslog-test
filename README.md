# docker-centos7-rsyslog-test
Docker rsyslog test (on CentOS 7.6)

```
# Build image
docker build -t centos7-rsyslog-test .

# Run container
docker run --rm -e TZ=Asia/Tokyo \
  --name docker-centos7-rsyslog-test \
  -ti docker-centos7-rsyslog-test /bin/bash

# --- container ---

# Run supervisord (for debug, append &)
sudo supervisord &

# Check if rsyslogd is started. 
top
  ～
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    1 docker    20   0   14388   3404   2992 S   0.0  0.0   0:00.06 bash
   31 root      20   0  133996   7732   6600 S   0.0  0.1   0:00.00 sudo
   32 root      20   0  116204  16184   7628 S   0.0  0.2   0:00.04 supervisord
   36 root      20   0  172352   3056   2648 S   0.0  0.0   0:00.00 rsyslogd
   42 docker    20   0   58740   4252   3716 R   0.0  0.1   0:00.00 top

Exit top command by pressing 'q'.

# Check if log file is created as the ordinary user's file.
logger -p local0.error "test"; ll /home/docker
echo "--------"; cat /home/docker/rsyslog-test.log
echo "--------"; cat /home/docker/test-whoami.txt

# exit
exit
```
