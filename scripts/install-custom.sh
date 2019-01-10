#!/usr/bin/env bash

set -eux

# -----------------------------------------------------------------------------
# Utils

build_pkgs () {
    su --preserve-environment \
        -c 'yes | aurbuild -d juxt -a <(aurqueue *)' rock
}

install_pkgs () {
    # We sync pacman to pick up changes to the juxt repo.
    pacman --noconfirm -Syu "$@"
}

# -----------------------------------------------------------------------------
# aurutils

AURUTILS_DIR="/tmp/aurutils"

git clone https://aur.archlinux.org/aurutils.git "$AURUTILS_DIR"
chmod go+w "$AURUTILS_DIR" # So we can create .SRCINFO files as the rock user.
cd "$AURUTILS_DIR"

# Install dependencies ourselves because we won't be able to elevate ourselves
# via sudo when we `makepkg`.
install_pkgs \
    jq \
    pacutils \
    repose

# You can't run makepkg as root, so we need to demote ourselves to a regular
# user.
#
# We skip the PGP check because we won't have AladW's GPG key at this point.
#
# TODO Pull in GPG key and use it to check package.
chown -R rock "$AURUTILS_DIR"
su --preserve-environment -c 'makepkg --skippgpcheck' rock

# We could install the build package immediately with `pacman -U` at this point,
# but to treat aurutils in the same way we will other AUR/private packages we do
# the update-repo-install-from-repo dance instead.
#
# This approach also has the advantage of keeping the packaged version of
# aurutils around if someone ever wants/needs to downgrade.
repose -vf juxt -r /var/cache/pacman/juxt
install_pkgs aurutils

# Now that we've installed aurutils we can remove the AUR repo.
rm -rf "$AURUTILS_DIR"

# -----------------------------------------------------------------------------
# Custom packages

# Recursively set permissions so `Makefile` et al can be found by the rock user.
chown -R rock "$PKG_DIR"

chmod -R 774 "$PKG_DIR"

# This is the directory in the juxt/rock repo with all the directories
# containing PKGBUILD files.
cd "$PKG_DIR"

# Dependencies from AUR of our packages need fetching in order to be available
# for builds.  Currently there doesn't appear to be a way to automatically get
# list.
echo 'python2-pystache' | su --preserve-environment -c 'aurfetch' rock

# Packages in AUR etc. have both a `PKGBUILD` file and a `.SRCINFO`. As we don't
# want to have to remember to create this src info file everytime we edit a
# package definition we create the files only when we need them.
#
# We use make because we can avoid all the shell escaping trouble with something
# like using `find` and redirecting output.
su --preserve-environment -c 'make' rock

# Now we find all the packages and write a manifest of the directories
# containing package definitions.
build_pkgs

# Install
install_pkgs \
    codedeploy-agent \
    journald-cloud-watch-script \
    systemd-cloud-watch \
    aws-cfn-bootstrap

# To install any packages from the AUR can now be done like so:
#     aursync <pkg0> <pkg1> <pkg2> ...
