```
docker run -d --device=/dev/net/tun --net=host --cap-add=NET_ADMIN --cap-add=SYS_ADMIN -e NW_ID=<network id> -e NW_TOKEN=<token> -v /var/lib/zerotier-one:/var/lib/zerotier-one spanda/zerotier
```

参考 [trawor/zerotier](https://github.com/trawor/zerotier)