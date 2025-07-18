#!/bin/bash

exec /usr/bin/node_exporter \
  --web.listen-address="${NodeIP:-0.0.0.0}:9100" \
  --path.procfs=/host/proc \
  --path.sysfs=/host/sys \
  --collector.filesystem.fs-types-exclude="^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$" \
  --collector.filesystem.mount-points-exclude="^/(dev|proc|sys|var/lib/docker/.+)($|/)"
