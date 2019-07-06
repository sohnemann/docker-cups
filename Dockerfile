# Base image
ARG ARCH=amd64
FROM $ARCH/debian:buster-slim

# Prepare multi arch build
COPY qemu-* /usr/bin/

# Maintainer
MAINTAINER Florian Schwab <me@ydkn.io>

# install packages
RUN apt-get update \
  && apt-get install -y \
    sudo \
    cups \
    cups-bsd \
    cups-filters \
    foomatic-db-compressed-ppds \
    printer-driver-all \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# add print user
RUN adduser --home /home/print --shell /bin/bash --gecos "print" --disabled-password print \
  && adduser print sudo \
  && adduser print lp \
  && adduser print lpadmin

# disable sudo password checking
RUN echo 'print ALL=(ALL:ALL) ALL' >> /etc/sudoers

# enable access to CUPS
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# cleanup
RUN rm -f /usr/bin/qemu-*-static /app/qemu-*-static

# volumes
VOLUME ["/etc/cups/printers.conf"]
VOLUME ["/etc/cups/ppd"]

# ports
EXPOSE 631

# default command
CMD ["/usr/sbin/cupsd", "-f"]
