#!/bin/sh

mkdir -p /tmp/g
chmod +t /tmp/g

export TMPDIR=/tmp/g
bundler exec puma config.ru
