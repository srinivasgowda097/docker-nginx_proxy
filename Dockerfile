FROM centos:centos7
MAINTAINER Iain Hadgraft <ihadgraft@gmail.com>

# Add nginx
RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

RUN yum -y install docker nginx && yum -y clean all

ADD start.sh /scripts/start.sh

CMD /scripts/start.sh && nginx && /bin/bash

