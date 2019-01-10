#!/usr/bin/env bash

set -eux

pacman --noconfirm -Syu "python2"

working_dir="/tmp/aws-cfn-bootstrap"

mkdir -p "$working_dir"

cd "$working_dir"
wget https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-1.4-30.tar.gz

tar xzf aws-cfn-bootstrap*.tar.gz
cd aws-cfn-bootstrap-1*/

sed -i "s/env python'/env python2'/" setup.py
python2 setup.py install

rm -rf "$working_dir"
