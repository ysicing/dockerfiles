#!/bin/bash
set -e

# 使用 include_dir 加载自定义配置（幂等）
if ! grep -Fxq "include_dir = '/etc/postgresql/conf.d'" "$PGDATA/postgresql.conf"; then
    echo "include_dir = '/etc/postgresql/conf.d'" >> "$PGDATA/postgresql.conf"
    echo "Custom configuration directory added to postgresql.conf"
fi

# 此时仅有初始化临时实例运行；沿用原启动参数重启，确保创建 pg_cron 前已预加载
pg_ctl -D "$PGDATA" -m fast -w restart
