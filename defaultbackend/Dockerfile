FROM ysicing/goa AS goa

COPY . /go/src

WORKDIR /go/src

RUN go build

FROM ysicing/alpine

COPY --from=goa /go/src/defaultbackend /bin/defaultbackend

RUN chmod +x /bin/defaultbackend

CMD /bin/defaultbackend
