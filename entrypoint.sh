#!/bin/sh

mkdir -p /tmp/g
chmod +t /tmp/g

export TMPDIR=/tmp/g
puma config.ru
