FROM golang:alpine3.12 AS build
RUN apk --no-cache add git gcc g++ musl-dev
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/...
WORKDIR /go/src/github.com/awslabs/amazon-ecr-credential-helper
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
RUN go build -ldflags "-s -w" -installsuffix cgo -a -o /ecr-login \
    ./ecr-login/cli/docker-credential-ecr-login


FROM docker:latest
RUN \
	apk -Uuv add make gcc groff less bash \
		musl-dev libffi-dev openssl-dev \
		python3-dev py-pip jq curl && \
	pip install awscli docker-compose && \
	rm /var/cache/apk/*
COPY --from=build /ecr-login /usr/bin/docker-credential-ecr-login
RUN mkdir /root/.docker
COPY config.json /root/.docker/config.json

