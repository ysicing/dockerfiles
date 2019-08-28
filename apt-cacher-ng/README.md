```
# Debian
 
cat > /etc/apt/apt.conf.d/00aptproxy <<EOF
Acquire::http::Proxy "http://172.16.16.55:3142";
Acquire::https::Proxy "http://172.16.16.55:3142";
EOF
apt update 
apt install -y git
 
# CentOS
 
cat >> /etc/yum.conf <<EOF
proxy=http://172.16.16.55:3142
EOF

```
