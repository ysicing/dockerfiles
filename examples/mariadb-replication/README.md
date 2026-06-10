# MariaDB 主从复制示例

基于 `ysicing/mariadb` 镜像，用 docker-compose 演示一主一从（GTID）复制。镜像已默认开启 `log_bin`、`binlog_format=ROW`、`gtid_strict_mode=ON`，所以主库无需任何额外配置。

> MariaDB 与 MySQL 复制语法不同（`CHANGE MASTER` / `START SLAVE` / `MASTER_USE_GTID`）。MySQL 见 [../mysql-replication/README.md](../mysql-replication/README.md)。

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `docker-compose.yml` | 一主（3306）一从（3307）服务定义 |
| `slave.cnf` | 从库专属配置，覆盖 `server-id=2` 并设为只读 |

## 1. 启动主从容器

```bash
docker compose up -d
# 等待两个容器都 healthy
docker compose ps
```

主库用镜像默认 `server-id=1`；从库通过 `slave.cnf` 覆盖为 `2` 并设 `read_only=ON`。与 MySQL 不同，MariaDB 的 `read_only` 不会阻断镜像初始化，可以直接写进配置文件实现持久化只读。

## 2. 主库创建复制账号

```bash
docker exec -i mariadb-master mariadb -uroot -prootpass <<'SQL'
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'replpass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
SQL
```

## 3. 从库指向主库并启动复制

容器间通过 compose 网络互通，主库地址用容器名 `mariadb-master`。

```bash
docker exec -i mariadb-slave mariadb -uroot -prootpass <<'SQL'
CHANGE MASTER TO
  MASTER_HOST='mariadb-master',
  MASTER_PORT=3306,
  MASTER_USER='repl',
  MASTER_PASSWORD='replpass',
  MASTER_USE_GTID=slave_pos;   -- GTID 复制，从库自身记录复制位点
START SLAVE;
SQL
```

## 4. 验证

**查看复制状态**，关注两个线程都为 `Yes`、延迟为 0：

```bash
docker exec -i mariadb-slave mariadb -uroot -prootpass --vertical -e "SHOW SLAVE STATUS" \
  | grep -E "Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master"
# Slave_IO_Running: Yes
# Slave_SQL_Running: Yes
# Seconds_Behind_Master: 0
```

**端到端验证**：主库写、从库读。

```bash
# 主库写入
docker exec -i mariadb-master mariadb -uroot -prootpass -e "
CREATE DATABASE IF NOT EXISTS demo;
CREATE TABLE IF NOT EXISTS demo.t(id INT PRIMARY KEY AUTO_INCREMENT, v VARCHAR(32));
INSERT INTO demo.t(v) VALUES('hello');"

# 从库读取（应能读到 hello）
docker exec -i mariadb-slave mariadb -uroot -prootpass -e "SELECT * FROM demo.t;"
```

> 从库已设 `read_only`，应用账号写入会被 `ERROR 1290` 拒绝。注意 MariaDB 的 `read_only` 不限制有 SUPER 权限的 root（无 MySQL 的 `super_read_only`），但挡住应用账号误写已满足目标。

## 清理

```bash
docker compose down -v
```

## 用于真实部署

上面用容器名和 `docker exec` 是为了示例方便。换成真实的两台 MariaDB 实例时，把 `docker exec -i <容器> mariadb ...` 换成 `mariadb -h <主机> -P <端口> -u<用户> -p`，其余 SQL 完全一致。注意：

- **主从 server-id 必须不同**，先 `SELECT @@server_id;` 确认。
- **从库连主库的地址**填从库实际可达主库的地址（NAT/端口映射场景可能与你管理用的地址不同）。
- **全新集群**才能直接用 GTID 从当前位点开始。主库已有历史数据时，先 `mariadb-dump --master-data --gtid` 导入从库再配复制。

## 常见问题

| 现象 | 原因与处理 |
| --- | --- |
| `Slave_IO_Running: Connecting` | 网络不通 / 账号密码错 / 复制账号 host 不匹配。检查 `Last_IO_Error`。 |
| `server-id` 冲突 | 主从 server-id 相同。修改从库 `slave.cnf`。 |
| root 能写只读从库 | 正常。MariaDB 的 `read_only` 不限制 root（有 SUPER 权限），它阻止的是应用账号误写。 |

## 与 MySQL 的语法差异

| | MySQL | MariaDB |
| --- | --- | --- |
| 配置复制 | `CHANGE REPLICATION SOURCE TO` | `CHANGE MASTER TO` |
| GTID 选项 | `SOURCE_AUTO_POSITION=1` | `MASTER_USE_GTID=slave_pos` |
| 启停复制 | `START/STOP REPLICA` | `START/STOP SLAVE` |
| 查看状态 | `SHOW REPLICA STATUS` | `SHOW SLAVE STATUS` |
| 持久化只读 | `SET PERSIST super_read_only`（配置文件会阻断初始化） | 配置文件 `read_only=ON`（不阻断） |
| 公钥认证 | 需 `GET_SOURCE_PUBLIC_KEY=1` | 不需要 |
