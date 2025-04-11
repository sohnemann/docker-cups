# base image
ARG ARCH=amd64
FROM $ARCH/debian:bookworm-slim

# args
ARG VCS_REF
ARG BUILD_DATE

# environment
ENV ADMIN_PASSWORD=admin

# labels
#LABEL maintainer="Florian Schwab <me@ydkn.io>" \
#  org.label-schema.schema-version="1.0" \
#  org.label-schema.name="ydkn/cups" \
#  org.label-schema.description="Simple CUPS docker image" \
#  org.label-schema.version="0.1" \
#  org.label-schema.url="https://hub.docker.com/r/ydkn/cups" \
#  org.label-schema.vcs-url="https://gitlab.com/ydkn/docker-cups" \
#  org.label-schema.vcs-ref=$VCS_REF \
#  org.label-schema.build-date=$BUILD_DATE

# install packages
RUN apt-get update \
  && apt-get install -y \
  sudo \
  cups \
  cups-bsd \
  cups-filters \
  curl \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -O https://www.sato-global.com/files/Printer_Drivers/SATO_CUPS_Driver/Linux/SATOLinuxDriver_x64.zip \
    && unzip SATOLinuxDriver_x64.zip \
    && apt-get install ./satodriver-2.30.0-linux-4.15-x86_64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# add print user
RUN adduser --home /home/admin --shell /bin/bash --gecos "admin" --disabled-password admin \
  && adduser admin sudo \
  && adduser admin lp \
  && adduser admin lpadmin

# disable sudo password checking
RUN echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

# enable access to CUPS
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid) \
  && echo "ServerAlias *" >> /etc/cups/cupsd.conf

# copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

# entrypoint
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

# make entrypoint executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# default command
CMD ["cupsd", "-f"]

# volumes
VOLUME ["/etc/cups"]

# ports
EXPOSE 631
