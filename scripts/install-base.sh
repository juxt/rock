#!/usr/bin/env bash

set -eux

# -----------------------------------------------------------------------------
# Fix sudoers permissions

chown root:root /etc/sudoers
chmod 440 /etc/sudoers

# -----------------------------------------------------------------------------
# Fix makepkg.conf permissions

chown root:root /etc/makepkg.conf
chmod 644 /etc/makepkg.conf

# -----------------------------------------------------------------------------
# Rock user

# Group for running pacman commands without needing to enter a password.
groupadd build

# We need a user to make packages later as Arch doesn't like you building
# packages as root.
#
# Also, we don't want to SSH in as root, so need a user to default to.
useradd \
    --create-home \
    --shell /usr/bin/bash \
    --groups "wheel,build" \
    rock

# -----------------------------------------------------------------------------
# Base packages

# aws-cli: command-line access to AWS API
# git: version control - access to source code
# termite-terminfo: required to make termite work properly when ssh'ing
# wget: access to terraform software

pacman --noconfirm -Syu \
    aws-cli \
    git \
    termite-terminfo \
    unzip \
    wget

# -----------------------------------------------------------------------------
# Private repo

cat <<EOF > /etc/pacman.d/juxt
[options]
CacheDir = /var/cache/pacman/pkg
CacheDir = $REPO_DIR
CleanMethod = KeepCurrent

[juxt]
SigLevel = Optional TrustAll
Server = file://$REPO_DIR
EOF

cat <<EOF >> /etc/pacman.conf
Include = /etc/pacman.d/juxt
EOF

install --owner root --group wheel --mode 774 -d "$PKG_DIR"
install --owner root --group wheel --mode 774 -d "$REPO_DIR"

# Create a new repo that the rock user can update.
repo-add "$REPO_DIR"/juxt.db.tar
chown root:wheel "$REPO_DIR"/juxt.{db,files}.tar
chmod 664 "$REPO_DIR"/juxt.{db,files}.tar
