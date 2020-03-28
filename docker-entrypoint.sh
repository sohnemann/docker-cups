#!/bin/bash -e

echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | passwd admin

if [ ! -f /etc/cups/printers.conf ]; then
  cp -rpn /etc/cups-skel/* /etc/cups/
fi

exec "$@"
