#!/usr/bin/env bash

set -eux

# -----------------------------------------------------------------------------
# Packages from core/extra/community etc.

pacman --noconfirm -Sy \
       clojure \
       rlwrap \
       jdk20-openjdk

# -----------------------------------------------------------------------------
# AUR packages

# First we need to pull down the package definitions, and build the packages.
#
# NOTE WE don't preserve environment because we don't want to use root's home
# directory.
# su -c 'aursync boot leiningen' rock

# With the packages now cached locally we can install them with Pacman.
#_pacman --noconfirm -Sy \
#_    boot \
#_    leiningen
