#!/usr/bin/env bash

set -eux

pacman-key --init
pacman-key --populate
reflector --country GB,FR,DE --protocol https,http --age 72 --score 30 -n 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman --noconfirm -Sy archlinux-keyring
sudo pacman --noconfirm -Syu
