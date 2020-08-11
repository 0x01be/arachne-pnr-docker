FROM 0x01be/icestorm as icestorm

FROM alpine as builder

COPY --from=icestorm /opt/icestorm/ /opt/icestorm/

RUN apk add --no-cache --virtual arachne-build-dependencies \
    git \
    build-base

RUN git clone --depth 1 https://github.com/YosysHQ/arachne-pnr.git /arachne-pnr

WORKDIR /arachne-pnr

RUN ICEBOX=/opt/icestorm/share/icebox/ make
RUN ICEBOX=/opt/icestorm/share/icebox/ DESTDIR=/opt/arachne-pnr/ make install

FROM alpine

COPY --from=builder /opt/arachne-pnr/usr/local/ /opt/arachne-pnr/

RUN apk add --no-cache --virtual arachne-runtime-dependencies \
    libstdc++ \
    libgcc

ENV PATH $PATH:/opt/arachne-pnr/bin/

