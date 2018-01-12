FROM centos:7
MAINTAINER Andrea Sosso <andrea@sosso.me>

ENV MAXSCALE_VERSION 2.1.13

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \
    && yum -y install https://downloads.mariadb.com/enterprise/yzsw-dthq/generate/10.0/mariadb-enterprise-repository.rpm \
	wget \
    && yum -y update \
    #&& yum -y install maxscale-$MAXSCALE_VERSION \
    && yum clean all \
    && rm -rf /tmp/*

RUN wget https://downloads.mariadb.com/MaxScale/$MAXSCALE_VERSION/centos/7/x86_64/maxscale-$MAXSCALE_VERSION-1.centos.7.x86_64.rpm
RUN yum -y install ./maxscale-$MAXSCALE_VERSION-1.centos.7.x86_64.rpm

# Move configuration file in directory for exports
RUN mkdir -p /etc/maxscale.d \
    && cp /etc/maxscale.cnf.template /etc/maxscale.d/maxscale.cnf \
    && ln -sf /etc/maxscale.d/maxscale.cnf /etc/maxscale.cnf

RUN maxkeys
RUN maxpasswd /var/lib/maxscale/ "%1&b0bZitvWsOV"

# VOLUME for custom configuration
VOLUME ["/etc/maxscale.d"]

# EXPOSE the MaxScale default ports

## RW Split Listener
EXPOSE 4006

## Read Connection Listener
EXPOSE 4008

## Debug Listener
EXPOSE 4442

## CLI Listener
EXPOSE 6603

# Running MaxScale
ENTRYPOINT ["/usr/bin/maxscale", "-d"]
