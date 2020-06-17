#!/usr/bin/env bash

set -eux

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
