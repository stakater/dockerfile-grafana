# From & maintainer
FROM                stakater/base-alpine:latest
MAINTAINER          Rasheed Amir <rasheed@aurorasolutions.io>

ARG                 GRAFANA_VERSION

# for installing kairosdb datasource
ENV                 GF_INSTALL_PLUGINS=grafana-kairosdb-datasource

RUN                 apk add --no-cache openssl
RUN                 wget --no-check-certificate -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub
RUN                 wget --no-check-certificate https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk
RUN                 apk add glibc-2.23-r3.apk
RUN                 wget --no-check-certificate https://grafanarel.s3.amazonaws.com/builds/grafana-$GRAFANA_VERSION.linux-x64.tar.gz
RUN                 tar -xzf grafana-$GRAFANA_VERSION.linux-x64.tar.gz
RUN                 mv grafana-$GRAFANA_VERSION/ grafana/
RUN                 sed -i 's,data = data,data = data/db,g' grafana/conf/defaults.ini
RUN                 rm grafana-$GRAFANA_VERSION.linux-x64.tar.gz /etc/apk/keys/sgerrand.rsa.pub glibc-2.23-r3.apk
RUN                 apk del openssl

VOLUME              ["/grafana/conf", "/grafana/data/db", "/grafana/data/log", "/grafana/data/plugins"]
WORKDIR             /grafana
CMD                 ["./bin/grafana-server"]

