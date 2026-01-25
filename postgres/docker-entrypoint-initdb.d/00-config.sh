#!/bin/bash
set -e

# 使用 include_dir 加载自定义配置（幂等）
if ! grep -q "include_dir = '/etc/postgresql/conf.d'" "$PGDATA/postgresql.conf"; then
    echo "include_dir = '/etc/postgresql/conf.d'" >> "$PGDATA/postgresql.conf"
    echo "Custom configuration directory added to postgresql.conf"
fi
