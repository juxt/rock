#!/usr/bin/env bash

set -eux

pacman-key --init
pacman-key --populate
reflector --country "GB" --protocol https,http --score 20 --sort rate --save /etc/pacman.d/mirrorlist
