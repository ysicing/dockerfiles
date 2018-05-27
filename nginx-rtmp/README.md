```
docker run      \
    -p 1935:1935        \
    -p 8080:8080        \
    -e RTMP_STREAM_NAMES=live,test   \
    -e RTMP_PUSH_URLS=rtmp://live.youtube.com/myname/streamkey
    spanda/nginx-rtmp
```
OBS
```
rtmp://<your server ip>/live/test
```
Usage
```
rtmp://<your server ip>/live/test
http://<your server ip>/hls/test.m3u8
```