#!/bin/bash
set -e

# 启用常用扩展
# 注意: auto_explain 不需要 CREATE EXTENSION，通过 shared_preload_libraries 预加载后自动工作

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- pgvector (向量相似度搜索，用于 AI/ML)
    CREATE EXTENSION IF NOT EXISTS vector;

    -- UUID 生成
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

    -- 三元组匹配，用于模糊搜索
    CREATE EXTENSION IF NOT EXISTS pg_trgm;

    -- 查询统计收集 (需要 shared_preload_libraries 预加载)
    CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

    -- 全文搜索去重音
    CREATE EXTENSION IF NOT EXISTS unaccent;

    -- 加密函数
    CREATE EXTENSION IF NOT EXISTS pgcrypto;

    -- B-tree GIN 索引支持
    CREATE EXTENSION IF NOT EXISTS btree_gin;

    -- B-tree GiST 索引支持
    CREATE EXTENSION IF NOT EXISTS btree_gist;

    -- 键值存储类型
    CREATE EXTENSION IF NOT EXISTS hstore;

    -- 层级数据类型
    CREATE EXTENSION IF NOT EXISTS ltree;

    -- 模糊字符串匹配
    CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
EOSQL

echo "Extensions enabled successfully!"
