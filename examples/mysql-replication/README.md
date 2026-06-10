# MySQL 主从复制示例

基于 `ysicing/mysql` 镜像，用 docker-compose 演示一主一从（GTID）复制。镜像已默认开启 `log_bin`、`binlog_format=ROW`、`gtid_mode=ON`，所以主库无需任何额外配置。

> MariaDB 的语法不同，见 [../mariadb-replication/README.md](../mariadb-replication/README.md)。

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `docker-compose.yml` | 一主（3306）一从（3307）服务定义 |
| `slave.cnf` | 从库专属配置，覆盖 `server-id=2` |

## 1. 启动主从容器

```bash
docker compose up -d
# 等待两个容器都 healthy
docker compose ps
```

主库用镜像默认 `server-id=1`；从库通过 `slave.cnf` 覆盖为 `2`（`zz-` 前缀确保在镜像自带 `custom.cnf` 之后加载）。

## 2. 主库创建复制账号

```bash
docker exec -i mysql-master mysql -uroot -prootpass <<'SQL'
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED WITH caching_sha2_password BY 'replpass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
SQL
```

## 3. 从库指向主库并启动复制

容器间通过 compose 网络互通，主库地址用容器名 `mysql-master`。

```bash
docker exec -i mysql-slave mysql -uroot -prootpass <<'SQL'
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='mysql-master',
  SOURCE_PORT=3306,
  SOURCE_USER='repl',
  SOURCE_PASSWORD='replpass',
  SOURCE_AUTO_POSITION=1,     -- GTID 自动定位，无需 binlog 文件名和位点
  GET_SOURCE_PUBLIC_KEY=1;    -- caching_sha2_password 非 SSL 连接需获取主库公钥
START REPLICA;
SQL
```

## 4. 从库设只读（推荐）

```bash
docker exec -i mysql-slave mysql -uroot -prootpass \
  -e "SET PERSIST super_read_only = ON;"
```

> 只读不要写进配置文件：官方镜像首次初始化要写 root 密码、建库，启动即只读会以 `ERROR 1290` 阻断初始化。所以这里用 `SET PERSIST`（持久化，重启保留）。

## 5. 验证

**查看复制状态**，关注两个线程都为 `Yes`、延迟为 0：

```bash
docker exec -i mysql-slave mysql -uroot -prootpass --vertical -e "SHOW REPLICA STATUS" \
  | grep -E "Replica_IO_Running|Replica_SQL_Running|Seconds_Behind_Source"
# Replica_IO_Running: Yes
# Replica_SQL_Running: Yes
# Seconds_Behind_Source: 0
```

**端到端验证**：主库写、从库读。

```bash
# 主库写入
docker exec -i mysql-master mysql -uroot -prootpass -e "
CREATE DATABASE IF NOT EXISTS demo;
CREATE TABLE IF NOT EXISTS demo.t(id INT PRIMARY KEY AUTO_INCREMENT, v VARCHAR(32));
INSERT INTO demo.t(v) VALUES('hello');"

# 从库读取（应能读到 hello）
docker exec -i mysql-slave mysql -uroot -prootpass -e "SELECT * FROM demo.t;"
```

## 清理

```bash
docker compose down -v
```

## 用于真实部署

上面用容器名和 `docker exec` 是为了示例方便。换成真实的两台 MySQL 实例时，把 `docker exec -i <容器> mysql ...` 换成 `mysql -h <主机> -P <端口> -u<用户> -p`，其余 SQL 完全一致。注意：

- **主从 server-id 必须不同**，先 `SELECT @@server_id;` 确认。
- **从库连主库的地址**填从库实际可达主库的地址（NAT/端口映射场景可能与你管理用的地址不同）。
- **全新集群**才能直接用 GTID 从当前位点开始。主库已有历史数据时，先 `mysqldump --master-data` 导入从库再配复制。

## 常见问题

| 现象 | 原因与处理 |
| --- | --- |
| `Replica_IO_Running: Connecting` | 网络不通 / 账号密码错 / 复制账号 host 不匹配。检查 `Last_IO_Error`。 |
| `ERROR 1290 super-read-only` | 只读写进了配置文件，阻断初始化。改用 `SET PERSIST`。 |
| `server-id` 冲突 | 主从 server-id 相同。修改从库 `slave.cnf`。 |
| `Authentication ... public key` | 缺 `GET_SOURCE_PUBLIC_KEY=1`，或改用 SSL 连接。 |
