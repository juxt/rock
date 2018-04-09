#!/usr/bin/env bash

set -eux

# jdk8-openjdk: many of our applications run on a JVM
# aws-cli: command-line access to AWS API
# git: version control - access to source code
# wget: access to terraform software
# termite-terminfo: required to make termite work properly when ssh'ing

pacman --noconfirm -Syu \
    aws-cli \
    clojure \
    git \
    jdk8-openjdk \
    termite-terminfo \
    unzip \
    wget \
