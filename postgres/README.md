# PostgreSQL 镜像

基于 PostgreSQL 18 的 pgvector Trixie 镜像，额外安装 HypoPG 和 pg_cron。
PostgreSQL 18 的数据卷应挂载到 `/var/lib/postgresql`。

## 初始化

- 在 `POSTGRES_DB` 中启用 `vector`、`hypopg`、`uuid-ossp`、`pg_trgm`、
  `pg_stat_statements`、`unaccent`、`pgcrypto`、`btree_gin`、`btree_gist`、
  `hstore`、`ltree` 和 `fuzzystrmatch`。
- 在 `postgres` 库中启用 `pg_cron`；每个实例只在这个库维护调度元数据。
- 通过 `/etc/postgresql/conf.d/custom.conf` 预加载 `pg_stat_statements`、
  `auto_explain` 和 `pg_cron`。
- 首次初始化写入配置引用后，重启仅监听本地 socket 的临时实例，使预加载先于扩展创建。

初始化脚本只在空数据目录执行。已有数据卷需要先确认 `postgresql.conf` 包含：

```conf
include_dir = '/etc/postgresql/conf.d'
```

更换镜像并重启数据库后，以超级用户连接 `postgres` 库执行：

```sql
CREATE EXTENSION IF NOT EXISTS pg_cron;
```

已有业务库需要单独启用新增的 HypoPG，新建业务库也不会自动继承上述扩展。
不要在已有实例上直接执行用于首次初始化的 `00-config.sh`。

## pg_cron

调度时区为 `Asia/Shanghai`，使用后台 worker 执行任务，并发上限为 2。
镜像不预置维护任务；任务并发仍受 `max_worker_processes` 及其他后台 worker 占用限制。

以下 SQL 在 `postgres` 库执行，示例业务库名为 `appdb`：

```sql
-- 每天北京时间 03:00 更新业务库统计信息
SELECT cron.schedule_in_database('app-analyze', '0 3 * * *', 'ANALYZE', 'appdb');

SELECT jobid, jobname, schedule, database, username, active FROM cron.job;
SELECT jobid, status, return_message, start_time, end_time
FROM cron.job_run_details ORDER BY start_time DESC LIMIT 20;

-- 取消示例任务
SELECT cron.unschedule('app-analyze');
```

普通用户需要拥有目标库和目标 SQL 的执行权限。管理员可在 `postgres` 库为指定角色授权；
跨库调度函数默认未向普通用户开放，需要额外授予执行权限：

```sql
GRANT USAGE ON SCHEMA cron TO app_role;
GRANT EXECUTE ON FUNCTION cron.schedule_in_database(text, text, text, text, text, boolean)
TO app_role;
```

执行历史 `cron.job_run_details` 不会自动清理，创建任务时应按需要安排历史保留策略。

## 功能测试

GitHub Actions 在发布前串行构建并测试 `linux/amd64` 和 `linux/arm64` 镜像。
两种架构均通过后才登录镜像仓库并执行发布。

本地已有 Docker 和待测镜像时，在仓库根目录执行：

```bash
bash postgres/tests/smoke.sh IMAGE
```

测试覆盖默认库和自定义业务库的扩展初始化、预加载配置、向量 HNSW 查询、
GIN/GiST 索引、HypoPG 假设索引、SQL 执行统计，以及普通用户的跨库调度、
任务成功/失败记录、数据持久化和重启后的调度恢复。
测试容器不开放端口，使用独立数据卷，结束时清理；失败时输出容器日志。
