# ChangeLog

## 20230620 更新

- 移除tailscale镜像
- kubectl更新到1.27.3版本
- 默认源换成mirrors.tencent.com

## 20230316 更新

- 优化go镜像

## 20230203 更新

- go更新到1.20版本
- kubectl更新到1.26.1版本
- helm更新到1.11.0版本
- tailscale更新到1.36.0版本

## 20230108 更新

- 更新tailscale版本到1.34.2
- 更新helm版本到1.10.3

## 20220926 更新

- 新增kubectl、helm、k8s
- 更新tailscale版本到1.30.2

## 20220812 更新

- go版本升级到 1.19

## 20220804 更新

- 移除derper

## 20220724 更新

- 更新tailscale版本到1.28.0
- 新增npm镜像

## 20220710 更新

- 更新tailscale版本到1.26.2
- 更新docker版本到20.10.17,golangci-lint版本到1.46.2

## 20220325 更新

- 更新go版本1.18
- 更新tailscale版本到1.22.2
- 更新derper版本到1.22.2
- 更新docker版本到20.10.14,golangci-lint版本到1.45.2

## 20220215 更新

- 更新Debian添加git命令
- 更新Docker版本到20.10.12,golangci-lint版本到1.44.0
- 更新tailscale版本到1.20.4

## 20211217 更新

- 更新tailscale版本到1.18.2

## 20211210 更新

- 更新tailscale版本到1.18.1

## 20211112 更新

- 新增tailscale/derper
- 更新tailscale版本到1.16.2

## 20211025 更新

- 更新tailscale版本到1.16.1

## 20211002 更新

- 更新tailscale版本到1.14.6

## 20210915 更新

- 更新debian默认源

## 20210903 更新

- 优化caddy2默认Caddyfile

## 20210831 更新

- 优化caddy2新增geocn插件

## 20210829 更新

- 新增caddy2

## 20210826 更新

- 新增tailscale镜像
- 移除kubectl,避免与tools里kubectl冲突

## 20210825 更新

- 移除httpie
- 优化debian基础镜像

## 20210822 更新

- debian基础镜像添加jq

## 20210821 更新

- 新增kubectl命令
- 新增httpie命令

## 20210818 更新

- 移除defaultbackend
- debian更新到bullseye
- god更新到1.17-bullseye
- goa更新到1.17
- python更新到3.9-slim-bullseye
- 修复debian debian-security源问题

## 20210721 更新

- 移除upx
- go基础镜像升级到1.16版本
- 更新debug

## 20210325 更新

- 更新debug

## 20210208 更新

- 新增debtools构建deb包

## 20201229 更新

- 调整alpine镜像为edge

## 20201206 更新

#### 调整

- 移除prometheus

#### 新增

- 添加debug镜像

## 20201118 更新

#### 调整

调整go debian/alpine 基础镜像，指定依赖1.15版本

## 20201113 更新

#### 新增

添加prometheus镜像

#### 调整

调整defaultbackend依赖

## 20201102 更新

#### 调整

- god 新增默认安装build-essential
- python 升级到3.9

## 20200811 更新

#### 废弃

- mysql相关工具镜像
- openresty
- ss

#### 调整

- ago alpine go二进制运行环境
- goa go alpine编译环境
- dgo debian go二进制运行环境
- god go debian 编译环境
- defaultbackend k8s ingress default images
