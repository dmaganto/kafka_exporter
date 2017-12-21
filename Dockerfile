FROM        alpine AS build
MAINTAINER  Daniel Maganto Martín <dmagantomartin@gmail.com>

RUN apk update
RUN apk add --update go=1.9.2-r1 gcc=6.4.0-r5 g++=6.4.0-r5 git
WORKDIR /
ENV GOPATH /kafka_exporter
RUN git clone -b feature/only_tls https://github.com/dmagantomartin/kafka_exporter 
RUN cd /kafka_exporter && (go get || true) && go build
 
FROM alpine
COPY --from=build /kafka_exporter/kafka_exporter /bin/kafka_exporter

EXPOSE     9308
ENTRYPOINT [ "/bin/kafka_exporter" ]
