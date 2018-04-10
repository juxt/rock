#!/usr/bin/env bash

# Disable Link-Local Multicast Name Resolution.
#
# From https://tools.ietf.org/html/rfc4795:
#
# > The goal of Link-Local Multicast Name Resolution (LLMNR) is to enable name
# > resolution in scenarios in which conventional DNS name resolution is not
# > possible. LLMNR supports all current and future DNS formats, types, and
# > classes, while operating on a separate port from DNS, and with a distinct
# > resolver cache. Since LLMNR only operates on the local link, it cannot be
# > considered a substitute for DNS.
#
# From https://bbs.archlinux.org/viewtopic.php?id=187986
echo "LLMNR=no" >> /etc/systemd/resolved.conf
