#!/bin/sh

mkdir /tmp/g
chmod +t /tmp/g

export TMPDIR=/tmp/g/tmp
bundler exec puma config.ru
