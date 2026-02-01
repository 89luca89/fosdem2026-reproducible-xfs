#!/bin/sh

set -x

mkosi \
  -d debian -r bookworm \
  -p base-files \
  -p dbus \
  -p systemd \
  -t directory \
  -o rootfs\
  --with-network false \
  --cache-directory=./.cache/ \
  --package-cache-directory=./.cache \
  --cache-directory=./.cache \
  --cache-only=always \
  --force \
  --seed aabbbbcc-aabb-bbcc-aabb-bbccaabbbbcc \
  --source-date-epoch 1234567890 \
  --remove-files /var/cache/ldconfig/aux-cache \
  --remove-files /var/log/alternatives.log 2>/tmp/build.log

truncate -s 1G rootfs.img

DETERMINISTIC_SEED=1 SOURCE_DATE_EPOCH=1234567890 \
  ~/Projects/Personal/xfsprogs-dev/mkfs/mkfs.xfs \
    -m uuid=aabbbbcc-aabb-bbcc-aabb-bbccaabbbbcc \
    -p ./rootfs/ rootfs.img
