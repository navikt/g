#!/bin/sh

mkdir /tmp/g
chmod +t /tmp/g

TMPDIR=/tmp/g/tmp
bundler exec puma config.ru
