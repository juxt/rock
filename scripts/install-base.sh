#!/usr/bin/env bash

set -eux

# -----------------------------------------------------------------------------
# Base packages

# aws-cli: command-line access to AWS API
# git: version control - access to source code
# termite-terminfo: required to make termite work properly when ssh'ing
# wget: access to terraform software
# man-db: manual pages

pacman --noconfirm -Syu \
    aws-cli \
    git \
    termite-terminfo \
    unzip \
    wget \
    man-db \
    vim
